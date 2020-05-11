import SwiftUI
import Combine

final class ImageLoadService: ObservableObject {

    @Published private(set) var image: UIImage = UIImage()

    private var cancellables: [AnyCancellable] = []

    func load(from url: URL) {
         URLSession.shared.dataTaskPublisher(for: url)
            .compactMap { (data, _) -> UIImage? in
                UIImage(data: data)
            }
            .catch { _ in Just(UIImage()) }
            .receive(on: RunLoop.main)
            .assign(to: \.image, on: self)
            .store(in: &cancellables)
    }

}

struct RemoteImage: View {

    @ObservedObject var imageLoad = ImageLoadService()

    init(url: URL) {
        imageLoad.load(from: url)
    }

    var body: some View {
        Image(uiImage: imageLoad.image).resizable().frame(width: 50, height: 50)
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(url: URL(string: "https://avatars0.githubusercontent.com/u/10639145?v=4")!)
    }
}
