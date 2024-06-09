//
//  EventsView.swift
//  SwiftGenericNetworklayer
//
//  Created by Ibukunoluwa Akintobi on 07/06/2024.
//

import SwiftUI

struct EventsView: View {
    let viewModel = EventsViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Color.clear.onAppear{
            viewModel.getCombinedEvents()
        }
        Color.clear.task {
            await viewModel.getAsyncEvents()
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
