//
//  ContentView.swift
//  Shared
//
//  Created by Ricardo Masuda on 21/12/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var pokemonVM = PokemonViewModel()
    @State private var searchText = ""
    
    var filterdPokemon: [Pokemon] {
        if searchText == "" { return pokemonVM.pokemon }
        return pokemonVM.pokemon.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(filterdPokemon) { poke in
                    NavigationLink(destination: PokemonDetailView(pokemon: poke)){
                        HStack {
                            VStack (alignment: .leading,spacing: 5) {
                                Text(poke.name.capitalized)
                                    .font(.title)
                                HStack {
                                    Text(poke.type.capitalized)
                                        .italic()
                                    Circle()
                                        .foregroundColor(poke.typeColor)
                                        .frame(width: 10, height:10)
                                }
                                Text(poke.description)
                                    .font(.caption)
                                    .lineLimit(2)
                            }
                            
                            AsyncImage(url: URL(string: poke.imageURL)) {
                                phase in switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable()
                                        .interpolation(.none)
                                        .scaledToFit()
                                        .frame(width: 100, height:100)
                                case .failure:
                                    Image(systemName: "photo")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            
                        }
                    }
                }
            }
            .navigationTitle("Meu pokemon")
            .searchable(text: $searchText)
        }
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
