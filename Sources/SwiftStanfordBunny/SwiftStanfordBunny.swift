import Foundation
import simd
public protocol BunnyPointProtocol{
    var pos:SIMD3<Float> { get set }
    var normal:SIMD3<Float>{ get set }
    var color: SIMD4<UInt8>{ get set }
    var faces:[[Int]]{get set}
    init(pos: SIMD3<Float>, normal: SIMD3<Float>, color: SIMD4<UInt8>, faces:[[Int]])
}
public struct SwiftStanfordBunny<T:BunnyPointProtocol>{
    public static func instance() -> SwiftStanfordBunny<T> {
        return SwiftStanfordBunny<T>()
    }
    private init(){
        
    }
    class Obj{
        func parse(data:Data)throws->[T]{
            var vertices: [SIMD3<Float>] = []
            var normals: [SIMD3<Float>] = []
            var faces: [[Int]] = []
            let string = String(data: data, encoding: .utf8)
            let lines = string!.split(separator: "\n")
            for line in lines {
                let parts = line.split(separator: " ")
                switch parts[0] {
                case "v":
                    let x = Float(parts[1])!
                    let y = Float(parts[2])!
                    let z = Float(parts[3])!
                    vertices.append(SIMD3<Float>(x, y, z))
                case "vn":
                    let x = Float(parts[1])!
                    let y = Float(parts[2])!
                    let z = Float(parts[3])!
                    normals.append(SIMD3<Float>(x, y, z))
                case "f":
                    var face: [Int] = []
                    for part in parts[1...] {
                        let indices = part.split(separator: "/").map { Int($0)! - 1 }
                        face.append(indices[0])
                    }
                    faces.append(face)
                default:
                    break
                }
            }
            if vertices.count != normals.count {
                throw NSError(domain: "vertices and normals count missmatch", code: 0)
            }
            return (0..<vertices.count).map{ index in
                return T(pos: vertices[index], normal: normals[index], color: simd_uchar4.zero,faces: faces)
            }
        }
    }
    public func load() throws->[T] {
        guard let objURL = Bundle.module.url(forResource: "bunny", withExtension: "obj") else {
            throw NSError(domain: "resource not found", code: 0)
        }
        let objData = try! Data(contentsOf: objURL)
        let obj = Obj()
        let points = try! obj.parse(data: objData)
        return points
    }
}
