import GitHubExample
import SwiftUI
import Combine

class ContentViewModel: ObservableObject {
    let app: GitHubExampleApp
    @Published var repos: [Repository] = []
    @Published var query: String = "Swift"

    var cancellables: [AnyCancellable] = []

    init(app: GitHubExampleApp) {
        self.app = app
        app.subscribe { [weak self] event in
            DispatchQueue.main.async {
                switch event {
                case .repositories(let repos):
                    self?.repos = repos
                case .error(let error):
                    print(error)
                }
            }
        }
        $query.sink { queryString in
            app.search(query: queryString)
        }
        .store(in: &cancellables)
    }
}

extension Repository: Identifiable {}

struct ContentView: View {

    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.query)
                List {
                    ForEach(viewModel.repos) { repo in
                        HStack {
                            RemoteImage(url: URL(string: repo.owner.avatarURL)!)
                            VStack(alignment: .leading) {
                                Text(repo.fullName).font(.headline)
                                Text(repo.description ?? "")
                            }
                            .padding()
                            Spacer()
                        }
                    }
                    Text("Load More").onAppear {
                        self.viewModel.app.nextPage()
                    }
                }
            }
            .navigationBarTitle("GitHub Search 🔍")

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel(
            app: GitHubExampleApp(networkSession: NativeNetworkSession())
        ))
    }
}
