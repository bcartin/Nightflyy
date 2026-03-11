//
//  NFPHelpOption.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 8/14/25.
//

enum NFPHelpOption: String {
    
    case faq = "FAQs"
    case support = "Contact Support"
    case report = "Report a Problem"
    case issue = "Issue with a Venue"
    case feedback = "Give Feedback"
    case locations = "Nightflyy Plus locations"

    var associatedUrl: String {
        switch self {
        case .faq:
            return "https://www.nightflyy.com/faq"
        case .support:
            return "mailto:support@nightflyy.com"
        case .report:
            return "https://docs.google.com/forms/d/e/1FAIpQLSflgQjVBVOaY30L98C0QNiiHcdOFwyqg80VmNZ_Brj2QMWZGg/viewform?usp=sf_link"
        case .issue:
            return "https://docs.google.com/forms/d/e/1FAIpQLSeWZy0IyfyhO9G2K3Y_Wccx4F0jEeLBoroIJW7Es6AGd471yQ/viewform?usp=sf_link"
        case .feedback:
            return "https://docs.google.com/forms/d/e/1FAIpQLSfbmYUnsSO0WXux5ePm9xa795kjgSCEfME0pjJuqp9nZixVXg/viewform?usp=sf_link"
        case .locations:
            return "https://www.nightflyy.com/nightflyy-plus"
        }
    }
}
