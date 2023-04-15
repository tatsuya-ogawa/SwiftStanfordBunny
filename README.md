# SwiftStanfordBunny

This Swift package provides a way to load the polygon mesh of the Stanford Bunny as an array of points conforming to the `BunnyPoint` protocol. The `BunnyPoint` protocol defines the following properties:

- `pos`: Position information of type `SIMD3<Float>`
- `normal`: Normal vector of type `SIMD3<Float>`
- `color`: Color information of type `SIMD4<UInt8>`
- `init(pos:normal:color:)`: Initializer to create a `BunnyPoint` with the specified `pos`, `normal`, and `color` values.

## Usage

You can use the `StanfordBunny` class to load the polygon mesh of the Stanford Bunny as an array of points.

```swift
import SwiftStanfordBunny
// struct of your own code
struct BunnyPoint:BunnyPointProtocol{
    var pos: SIMD3<Float>
    var normal: SIMD3<Float>
    var color: SIMD4<Float>
    var uv: SIMD2<Float>
    init(pos: SIMD3<Float>, normal: SIMD3<Float>, color: SIMD4<Float>,uv: SIMD2<Float>) {
        self.pos = pos
        self.normal = normal
        self.color = color
        self.uv = uv
    }
}
let bunny = SwiftStanfordBunny<BunnyPoint>.instance()
let points = try! bunny.load()
```

The load function returns an array of points that conform to the BunnyPoint protocol.

Here is an example that iterates through each element of the array and prints out the point information:

```swift
for point in points {
    print("pos: \(point.pos), normal: \(point.normal), color: \(point.color)")
}
```
