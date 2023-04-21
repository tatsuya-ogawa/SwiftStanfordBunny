import XCTest
@testable import SwiftStanfordBunny

struct BunnyPoint:BunnyPointProtocol{
    var posision: SIMD3<Float>
    var normal: SIMD3<Float>
    var uv: SIMD2<Float>
    init(position: SIMD3<Float>, normal: SIMD3<Float>, uv:SIMD2<Float>) {
        self.posision = position
        self.normal = normal
        self.uv = uv
    }
}

final class SwiftStanfordBunnyTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let bunny = SwiftStanfordBunny<BunnyPoint>.instance()
        let (points,faces) = try! bunny.load()
        XCTAssertEqual(points.count, 37901)
        XCTAssertEqual(faces.count, 69630)
    }
}
