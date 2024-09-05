import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var eventTitle: String = ""
    @State private var eventDate: Date = Date()
    @State private var selectedCalendar: Calendar = Calendar(identifier: .gregorian)
    @State private var selectedContacts: [String] = []
    @State private var events: [Event] = []
    @State private var isAddingCustomEvent: Bool = false
    @State private var newCustomEventTitle: String = ""

    // لیست مناسبت‌های پیش‌فرض
    let defaultEvents = ["Birthday", "Anniversary", "Meeting", "Other"]

    var body: some View {
        NavigationView {
            VStack {
                // انتخاب تقویم
                Picker("Select Calendar", selection: $selectedCalendar) {
                    Text("Gregorian").tag(Calendar(identifier: .gregorian))
                    Text("Persian").tag(Calendar(identifier: .persian))
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // انتخاب تاریخ
                DatePicker("Select Date", selection: $eventDate, displayedComponents: .date)
                    .environment(\.calendar, selectedCalendar)
                    .padding()
                
                // اضافه کردن مناسبت سفارشی
                if isAddingCustomEvent {
                    TextField("Enter custom event", text: $newCustomEventTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        // افزودن مناسبت سفارشی به لیست
                        if !newCustomEventTitle.isEmpty {
                            let newEvent = Event(title: newCustomEventTitle, date: eventDate, contacts: selectedContacts)
                            events.append(newEvent)
                            saveEvent(newEvent) // ذخیره مناسبت
                            scheduleNotification(for: newEvent) // برنامه‌ریزی نوتیفیکیشن
                            newCustomEventTitle = ""
                            isAddingCustomEvent = false
                        }
                    }) {
                        Text("Save Custom Event")
                    }
                    .padding()
                } else {
                    Picker("Event Title", selection: $eventTitle) {
                        ForEach(defaultEvents, id: \.self) { event in
                            Text(event).tag(event)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                    Button(action: {
                        isAddingCustomEvent = true
                    }) {
                        Text("Add Custom Event")
                    }
                    .padding()
                }
                
                // دکمه انتخاب مخاطبین
                Button(action: {
                    fetchContacts()
                }) {
                    Text("Select Contacts")
                }
                .padding()

                // دکمه ذخیره مناسبت
                Button(action: {
                    let newEvent = Event(title: eventTitle, date: eventDate, contacts: selectedContacts)
                    events.append(newEvent)
                    saveEvent(newEvent)
                    scheduleNotification(for: newEvent)
                }) {
                    Text("Add Event")
                }
                .padding()

                // لیست مناسبت‌ها
                List(events, id: \.title) { event in
                    VStack(alignment: .leading) {
                        Text(event.title)
                        Text(event.date, style: .date)
                    }
                }
            }
            .navigationTitle("Event Reminder")
            .onAppear {
                loadEvents()
            }
        }
    }

    // متد برای انتخاب مخاطبین
    func fetchContacts() {
        // اینجا باید کدی برای انتخاب مخاطبین اضافه کنید
        // برای نمونه، فرض می‌کنیم مخاطبین به صورت دستی اضافه می‌شوند
        selectedContacts = ["Alice", "Bob"] // به طور نمونه
    }

    // متد برای ذخیره مناسبت‌ها
    func saveEvent(_ event: Event) {
        // برای ذخیره در پایگاه داده یا UserDefaults می‌توانید از اینجا استفاده کنید
    }

    // متد برای برنامه‌ریزی نوتیفیکیشن
    func scheduleNotification(for event: Event) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "\(event.title) is today!"
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day], from: event.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }

    // متد برای بارگذاری مناسبت‌ها
    func loadEvents() {
        // اینجا باید کدی برای بارگذاری مناسبت‌ها اضافه کنید
        // به عنوان نمونه، فرض می‌کنیم مناسبت‌ها به صورت دستی اضافه می‌شوند
        events = [
            Event(title: "Alice's Birthday", date: Date(), contacts: ["Alice"])
        ]
    }
}

struct Event {
    let title: String
    let date: Date
    let contacts: [String]
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
