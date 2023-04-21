import Foundation
import simd
public protocol BunnyPointProtocol{
    init(position: SIMD3<Float>, normal: SIMD3<Float>,uv:SIMD2<Float>)
}
public struct SwiftStanfordBunny<T:BunnyPointProtocol>{
    public static func instance() -> SwiftStanfordBunny<T> {
        return SwiftStanfordBunny<T>()
    }
    private init(){
        
    }
    class Obj{
        func parse(data:Data)throws->([T],[[Int]]){
            var vertices: [SIMD3<Float>] = []
            var normals: [SIMD3<Float>] = []
            var uvs: [SIMD2<Float>] = []
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
                 case "vt":
                    let x = Float(parts[1])!
                    let y = Float(parts[2])!
                    uvs.append(SIMD2<Float>(x, y))
                default:
                    break
                }
            }
            if vertices.count != normals.count {
                throw NSError(domain: "vertices and normals count missmatch", code: 0)
            }
            return ((0..<vertices.count).map{ index in
                return T(position: vertices[index], normal: normals[index],uv:uvs[index])
            },faces)
        }
    }
    public func load() throws->(points:[T],faces:[[Int]]) {
        guard let objURL = Bundle.module.url(forResource: "bunny", withExtension: "obj") else {
            throw NSError(domain: "resource not found", code: 0)
        }
        let objData = try! Data(contentsOf: objURL)
        let obj = Obj()
        let (points,faces) = try! obj.parse(data: objData)
        return (points,faces)
    }
}
