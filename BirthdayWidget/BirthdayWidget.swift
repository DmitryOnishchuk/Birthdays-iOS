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

struct BirthdayProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> BirthdayEntry {
        
        let contacts = [Contact(id: "0", name: "Test", birthday: Date(), birthdayNear: Date(), daysToBirthday: 1, futureAge: 18, photo: UIImage(named: "avatar")!)]
        
        return BirthdayEntry(date: Date(), contacts: contacts)
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (BirthdayEntry) -> ()) {
        let contacts = [Contact(id: "0", name: "Test", birthday: Date(), birthdayNear: Date(), daysToBirthday: 1, futureAge: 18, photo: UIImage(named: "avatar")!)]
        
        if context.isPreview {
            let entry = BirthdayEntry(date: Date(), contacts: contacts)
            completion(entry)
        } else {
            
            
            let entry = BirthdayEntry(date: Date(), contacts: contacts)
            completion(entry)
        }
    }
    
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let contacts = [Contact(id: "0", name: "Test", birthday: Date(), birthdayNear: Date(), daysToBirthday: 1, futureAge: 18, photo: UIImage(named: "avatar")!)]
        
        var entries: [BirthdayEntry] = [BirthdayEntry(date: Date(), contacts: contacts)]
        
        let threeSeconds: TimeInterval = 3
        var currentDate = Date()
        let endDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        while currentDate < endDate {
            let newScore = Double.random(in: 150...200)
            
            let entry = BirthdayEntry(date: currentDate, contacts: contacts)
            entries.append(entry)
            currentDate += threeSeconds
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
        
    }
}

struct BirthdayEntry: TimelineEntry {
    let date: Date
    let contacts: [Contact]
}

@main
struct BirthdayWidget: Widget {
    let kind: String = "BirthdayWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: BirthdayProvider()) { entry in
            BirthdayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct BirthdayWidgetEntryView : View {
    var entry: BirthdayProvider.Entry
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        default:
            List(entry.contacts){
                contact in ListRow(eachContact: contact)
            }
        }
    }
}

struct ContactList: View{
    var contacts: [Contact]
    var body: some View {
        List(contacts){
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


let contacts = [Contact(id: "0", name: "Test", birthday: Date(), birthdayNear: Date(), daysToBirthday: 1, futureAge: 18, photo: UIImage(named: "avatar")!)]

struct BirthdayWidgetEntryView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            BirthdayWidgetEntryView(entry: BirthdayEntry(date: Date(), contacts: contacts))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            BirthdayWidgetEntryView(entry: BirthdayEntry(date: Date(), contacts: contacts))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
