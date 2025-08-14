//
//  NFPHelpOption.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 8/14/25.
//

enum NFPHelpOption: String {
    
    case FAQ = "FAQs"
    case Support = "Contact Support"
    case Report = "Report a Problem"
    case Issue = "Issue with a Venue"
    case Feedback = "Give Feedback"
    case Locations = "Nightflyy Plus locations"

    var associatedUrl: String {
        switch self {
        case .FAQ:
            return "https://www.nightflyy.com/faq"
        case .Support:
            return "mailto:support@nightflyy.com"
        case .Report:
            return "https://docs.google.com/forms/d/e/1FAIpQLSflgQjVBVOaY30L98C0QNiiHcdOFwyqg80VmNZ_Brj2QMWZGg/viewform?usp=sf_link"
        case .Issue:
            return "https://docs.google.com/forms/d/e/1FAIpQLSeWZy0IyfyhO9G2K3Y_Wccx4F0jEeLBoroIJW7Es6AGd471yQ/viewform?usp=sf_link"
        case .Feedback:
            return "https://docs.google.com/forms/d/e/1FAIpQLSfbmYUnsSO0WXux5ePm9xa795kjgSCEfME0pjJuqp9nZixVXg/viewform?usp=sf_link"
        case .Locations:
            return "https://www.nightflyy.com/nightflyy-plus"
        }
    }
}
