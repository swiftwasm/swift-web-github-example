import { SwiftRuntime } from "javascript-kit-swift";
import { WASI } from "@wasmer/wasi";
import { WasmFs } from "@wasmer/wasmfs";


global._triggerDebugger = () => {
    debugger
};

const startWasiTask = async () => {

  const swift = new SwiftRuntime();
  const wasmFs = new WasmFs();

  // Output stdout and stderr to console
  const originalWriteSync = wasmFs.fs.writeSync;
  wasmFs.fs.writeSync = (fd, buffer, offset, length, position) => {
    const text = new TextDecoder("utf-8").decode(buffer);
    switch (fd) {
    case 1:
      console.log(text);
      break;
    case 2:
      console.error(text);
      break;
    }
    return originalWriteSync(fd, buffer, offset, length, position);
  };

  let wasi = new WASI({
    args: [], env: {},
    bindings: {
      ...WASI.defaultBindings,
      fs: wasmFs.fs
    }
  });

  const response = await fetch("GitHubExampleWeb.wasm");
  const importObject = {
    wasi_snapshot_preview1: wasi.wasiImport,
    javascript_kit: swift.importObjects(),
  };

  const { instance } = await (async () => {
    if (WebAssembly.instantiateStreaming) {
      return await WebAssembly.instantiateStreaming(response, importObject);
    } else {
      const responseArrayBuffer = await response.arrayBuffer();
      const wasmBytes = new Uint8Array(responseArrayBuffer).buffer;
      return await WebAssembly.instantiate(wasmBytes, importObject);
    }
  })();

  swift.setInstance(instance);
  wasi.start(instance);
};

startWasiTask().catch(console.error);
