//
//  PerkVideoFile.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/24/26.
//

import CoreTransferable
import UniformTypeIdentifiers

/// The branded perk video, shared as an MP4 movie. Sharing the bare file URL offers it as a link or
/// generic file, which apps such as Instagram reject even though they accept the same video from Photos.
struct PerkVideoFile: Transferable {

    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .mpeg4Movie) { video in
            SentTransferredFile(video.url)
        }
    }
}
