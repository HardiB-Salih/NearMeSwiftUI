//
//  SearchBarView.swift
//  NearMeSwiftUI
//
//  Created by HardiB.Salih on 6/16/24.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var search: String
    @Binding var isSearching: Bool
    let onClear: () -> Void
    var body: some View {
        VStack (spacing: 8){
            TextField("Search", text: $search)
                .padding(8)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color(.systemGray5), lineWidth: 1.0)
                }
                .overlay(alignment: .trailing, content: {
                    if isSearching || !search.isEmpty{
                        Button(action: {
                            onClear()
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .padding(10)
                                .foregroundStyle(Color(.systemGray))
                                .imageScale(.large)
                        })
                    }
                    
                })
                .onSubmit { isSearching = true }
            
            SearchOptionsView { searchTerm in
                search = searchTerm
                isSearching = true
            }
        }
        .padding()
    }
}

#Preview {
    SearchBarView(search: .constant(""), isSearching: .constant(true), onClear: { })
}
