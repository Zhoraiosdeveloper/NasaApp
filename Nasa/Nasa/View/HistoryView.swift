//
//  HistoryView.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 08/03/2024.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    
    @EnvironmentObject var homeViewModel : HomeViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FilterHistory.id, ascending: true)],
        animation: .default)
    private var history: FetchedResults<FilterHistory>
    @State private var showingOptions = false
    @State var selectedFilter:FilterHistory?
    @Environment(\.dismiss) var dismiss
 
    // MARK: Body -
    var body: some View {
        VStack {
            headerView
            if history.count == 0 {
                Spacer()
                VStack {
                    Image("Globus")
                    Text("Browsing history is empty.")
                        .foregroundColor(.layerTwo)
                }
                Spacer()
            }else {
                ScrollView {
                    ForEach(history,id:\.id) { data in
                        
                        HomeListItem(roverName: data.rover ?? "", cameraName: data.camera ?? "", date: data.date ?? "", imageURL: "")
                            .onTapGesture {
                                selectedFilter = data
                                showingOptions = true
                            }
                    }
                }.padding(.horizontal,10)
                    .confirmationDialog("Menu FIlter", isPresented: $showingOptions, titleVisibility: .visible) {
                        Button("Use") {
                            if let selectedFilter = selectedFilter {
                                homeViewModel.camera = selectedFilter.camera  ?? ""
                                homeViewModel.rover = selectedFilter.rover ?? ""
                                homeViewModel.seletedDate = selectedFilter.date ?? ""
                                NotificationCenter.default.post(name: Notification.Name.updateView, object: true )
                                dismiss()
                            }
                        }
                    
                        Button("Delete") {
                            if let selectedFilter = selectedFilter {
                                deleteCart(deletedHistory: selectedFilter)
                            }
                        }
                    }
                Spacer()
            }
                
        }
    }
    
    private func deleteCart(deletedHistory: FilterHistory){
        withAnimation {
            viewContext.delete(deletedHistory)
            do{
                try viewContext.save()
                
            }catch{
                print(error)
            }
        }
    }
}

// MARK: Header View -
extension HistoryView {
    var headerView: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Image("Left")
                })
                Text("History")
                    .font(Font.custom("SFPro-Bold", size: 34))
                    .frame(height: 44)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
        }
        .frame(height:80)
        .frame(maxWidth: .infinity)
        .background(Color.accentOne)
    }
}

