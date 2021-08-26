//
//  BirthdayWidget.swift
//  BirthdayWidget
//
//  Created by Dmitry Onishchuk on 20.08.2021.
//  Copyright © 2021 Dmitry Onishchuk. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        var myContacts = [
            Contact(id: "0", name: "Test", birthday: Date(), birthdayNear: Date(), daysToBirthday: 1, futureAge: 20, photo: UIImage(named: "avatar")!)
        ]
        
        return SimpleEntry(date: Date(), contactList: myContacts, configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        var myContacts = [
            Contact(id: "0", name: "Test", birthday: Date(), birthdayNear: Date(), daysToBirthday: 1, futureAge: 20, photo: UIImage(named: "avatar")!)
        ]
        let entry = SimpleEntry(date: Date(), contactList: myContacts, configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            
            var myContacts = [
                Contact(id: "0", name: "Test", birthday: Date(), birthdayNear: Date(), daysToBirthday: 1, futureAge: 20, photo: UIImage(named: "avatar")!)
            ]
            
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, contactList: myContacts, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let contactList: [Contact]
    let configuration: ConfigurationIntent
}

struct BirthdayWidgetEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        List(entry.contactList){
            contact in ListRow(eachContact: contact)
        }
    }
}

struct ContactList: View{
    var contactListMy: [Contact]
    var body: some View {
        List(contactListMy){
            contact in ListRow(eachContact: contact)
        }
    }
}

struct ListRow: View{
    var eachContact: Contact
    
    var body: some View{
        HStack{
            Text(eachContact.name)
            Spacer()
            Text(String(eachContact.daysToBirthday))
        }
    }
}

@main
struct BirthdayWidget: Widget {
    let kind: String = "BirthdayWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BirthdayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

var myContacts = [
    Contact(id: "0", name: "Test", birthday: Date(), birthdayNear: Date(), daysToBirthday: 1, futureAge: 20, photo: UIImage(named: "avatar")!)
]

struct BirthdayWidget_Previews: PreviewProvider {
    static var previews: some View {
        BirthdayWidgetEntryView(entry: SimpleEntry(date: Date(), contactList: myContacts, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
