import Foundation
import Utility

public class TopAlbums: Decodable {
    public let albums: [Album]

    private enum CodingKeys: String, CodingKey {
        case topAlbum = "topalbums"
        case albums = "album"
    }

    public required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topAlbum)
            albums = try nestedContainer.decode([Album].self, forKey: .albums)
        } catch let error {
            print("error = \(error)")
            throw error
        }
    }
}

public class Album: Decodable {
    public let title: String?

    private enum CodingKeys: String, CodingKey {
        case title = "name"
    }
}

extension ClientResponse {
    func map() -> Result<TopAlbums, Error> {
        if let data = data {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let topAlbums = try decoder.decode(TopAlbums.self, from: data)
                return .success(topAlbums)
            } catch {
                return .failure(error)
            }
        } else {
            let unknownError = NSError(domain: "", code: -1, userInfo: nil)
            return .failure(unknownError)
        }
    }
}
