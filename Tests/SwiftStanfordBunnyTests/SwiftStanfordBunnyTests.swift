import XCTest
@testable import SwiftStanfordBunny

struct BunnyPoint:BunnyPointProtocol{
    var pos: SIMD3<Float>
    var normal: SIMD3<Float>
    var color: SIMD4<UInt8>
    init(pos: SIMD3<Float>, normal: SIMD3<Float>, color: SIMD4<UInt8>) {
        self.pos = pos
        self.normal = normal
        self.color = color
    }
}

final class SwiftStanfordBunnyTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let bunny = SwiftStanfordBunny<BunnyPoint>.instance()
        let (points,faces) = try! bunny.load()
        XCTAssertEqual(points.count, 34817)
        XCTAssertEqual(faces.count, 69630)
    }
}
