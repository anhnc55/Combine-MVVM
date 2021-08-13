//
//  RepositoriesRow.swift
//  Combine-MVVM
//
//  Created by Anh Nguyen on 11/07/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct RepositoriesRow: View {
    @State var repository: Repository
    
    var body: some View {
        let navigator = RepositoryDetailNavigator(navigationController: UINavigationController())
        let useCase = RepositoryDetailUseCase()
        let viewModel = RepositoryDetailViewModel(navigator: navigator,
                                                  useCase: useCase,
                                                  repo: repository)
        let detailView = RepositoryDetailView(viewModel: viewModel)
        return NavigationLink(destination: detailView) {
            VStack {
                HStack {
                    AnimatedImage(url: repository.owner?.avatarUrl)
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(3.0)
                        .frame(width: 36, height: 36)
                    
                    Text(repository.owner?.login ?? "")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                HStack {
                    Text(repository.name ?? "")
                        .font(.headline)
                    Spacer()
                }
                HStack {
                    Text(repository.description ?? "")
                        .font(.callout)
                        .foregroundColor(.primary)
                    Spacer()
                }
                HStack {
                    HStack {
                        Image(systemName: "star")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.secondary)
                        Text(String(repository.stargazersCount ?? 0))
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 10, height: 10)
                            .foregroundColor(Color(UIColor.random()))
                        Text(repository.language ?? "")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
            }
            .padding([.top, .bottom], 8)
        }
    }
}
