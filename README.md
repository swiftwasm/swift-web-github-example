# swift-webpack-template

Kickstart your Swift, WebAssembly and Webpack project.

[Let's create your project](https://github.com/swiftwasm/swift-webpack-template/generate)

After cloning the project, please execute `./init-project.sh` to setup repository.

```sh
$ git clone https://github.com/your-account/YourNewProject.git
$ cd YourNewProject
$ ./init-project.sh
Creating new project 'YourNewProject'
Removing this script itself
Adding init commit
[master 5193e27] Init 'YourNewProject'
 11 files changed, 22 insertions(+), 55 deletions(-)
 rename Sources/{__PROJECT_NAME__/__PROJECT_NAME__.swift => YourNewProject/YourNewProject.swift} (75%)
 create mode 100644 Sources/YourNewProjectWeb/main.swift
 delete mode 100644 Sources/__PROJECT_NAME__Web/main.swift
 rename Tests/{__PROJECT_NAME__Tests/__PROJECT_NAME__Tests.swift => YourNewProjectTests/YourNewProjectTests.swift} (56%)
 delete mode 100755 init-project.sh
 ```
