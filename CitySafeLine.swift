import Foundation

class Contact {
    var name:String
    var contactNum:[String]
    var category:String?

    init(name:String, contactNum:[String], category:String){
        self.name = name
        self.contactNum = contactNum
        self.category = category
    }
}

func saveContactsToFile() {
    let fileName = "contacts.txt"
    let desktopPath = FileManager.default.currentDirectoryPath
    let filePath = desktopPath + "\\" + fileName

    var contactsString = ""
    for contact in contacts {
        let contactInfo = "\(contact.name),\(contact.contactNum.joined(separator: ",")),\(contact.category ?? "")"
        contactsString.append(contactInfo + "\n")
    }

    do {
        try contactsString.write(toFile: filePath, atomically: false, encoding: .utf8)
        
    } catch {
        print("Error saving contacts to \(fileName): \(error.localizedDescription)")
    }
}

func loadContactsFromFile() -> [Contact] {
    let fileName = "contacts.txt"
    let desktopPath = FileManager.default.currentDirectoryPath
    let filePath = desktopPath + "\\" + fileName
    
    do {

        let contactsString = try String(contentsOfFile: filePath, encoding: .utf8)
        
        let contactLines = contactsString.components(separatedBy: "\n")
        
        var loadedContacts = [Contact]()
        
        for line in contactLines {
            let contactComponents = line.components(separatedBy: ",")
            if contactComponents.count >= 2 {
                let name = contactComponents[0]
                let contactNums = contactComponents[1].components(separatedBy: ",")
                let category = contactComponents.count > 2 ? contactComponents[2] : ""
                let contact = Contact(name: name, contactNum: contactNums, category: category)
                loadedContacts.append(contact)
            }
        }
        
        return loadedContacts
    } catch {
        print("Error loading contacts from \(fileName): \(error.localizedDescription)")
        return []
    }
}

var contacts: [Contact] = []

print("Welcome To CitySafeLine")
contacts = loadContactsFromFile()
let currentDirectory = FileManager.default.currentDirectoryPath

print("Current working directory: \(currentDirectory)")
while(true){
    print("\n1 View Hotlines\n2 Add Hotline\n3 Update Hotline\n4 Search Hotline\n5 Remove Hotline\n0 Exit")
    if let input = readLine() {
        switch(input) {
            case "1":
                for contact in contacts {
                    print("Name: \(contact.name)")
                    print("Contact No.: \(contact.contactNum)")
                    print("Category: \(contact.category ?? "N/A")\n")
                }
            case "2":
                print("Contact Name: ")
                if let contName = readLine() {
                    print("Contact No.: ")
                    if let contNum = readLine() {
                        print("Contact Category: ")
                        if let contCat = readLine() {
                            contacts.append(Contact(name: contName, contactNum: [contNum], category: contCat))
                            saveContactsToFile()
                        } else {
                            print("Invalid input for Contact Category.")
                        }
                    } else {
                        print("Invalid input for Contact No.")
                    }
                } else {
                    print("Invalid input for Contact Name.")
                }
            case "3":
                print("Enter Contact Name to be updated: ")
                    if let conName = readLine() {
                        var contactFound = false 
                        
                        for contact in contacts {
                            if contact.name == conName {
                                print("Enter the new Contact Number: ")
                                if let newContNum = readLine() {
                                    
                                    contact.contactNum.append(newContNum)
                                    print("Contact Details updated.")
                                    contactFound = true 
                                    break 
                                } else {
                                    print("Invalid input for the new contact number.")
                                }
                            }
                        }
                        
                        if !contactFound {
                            print("Contact with the name \(conName) not found.")
                        }
                    }
            case "4":
                print("Enter the category to search for contacts: ")
                    if let searchCategory = readLine() {
                        var contactsInCategory = [Contact]()
                        
                        for contact in contacts {
                            if let contactCategory = contact.category, contactCategory.lowercased() == searchCategory.lowercased() {
                                contactsInCategory.append(contact)
                            }
                        }
                        
                        if contactsInCategory.isEmpty {
                            print("No contacts found in category: \(searchCategory)")
                        } else {
                            print("Contacts in category: \(searchCategory)")
                            for contact in contactsInCategory {
                                print("Name: \(contact.name)")
                                print("Contact Numbers: \(contact.contactNum)")
                            }
                        }
                    }
            case "5":
                print("Enter Contact Name to be removed: ")
                    if let conName = readLine() {
                        var indexToRemove: Int?
                        for (index, contact) in contacts.enumerated() {
                            if contact.name == conName {
                                indexToRemove = index
                                break
                            }
                        }
                        if let index = indexToRemove {
                            contacts.remove(at: index)
                            saveContactsToFile()
                            print("\(conName) has been removed.")
                        } else {
                            print("\(conName) not found in contacts.")
                        }
                    }
            case "0":
                print("Thank you for using CitySafeLine, Goodbye!")
                exit(0)
            default:
                print("Invalid input, Try again")
        }
}
}