import Foundation
import simd
public protocol BunnyPointProtocol{
    associatedtype Scalar where Scalar: SIMDScalar & LosslessStringConvertible
    init(position: SIMD3<Scalar>, normal: SIMD3<Scalar>,uv:SIMD2<Scalar>)
}
public struct SwiftStanfordBunny<T:BunnyPointProtocol>{
    public static func instance() -> SwiftStanfordBunny<T> {
        return SwiftStanfordBunny<T>()
    }
    private init(){
        
    }
    class Obj{
        func parse<Scalar>(data:Data)throws->([T],[[Int]]) where Scalar == T.Scalar{
            var vertices: [SIMD3<Scalar>] = []
            var normals: [SIMD3<Scalar>] = []
            var uvs: [SIMD2<Scalar>] = []
            var faces: [[Int]] = []
            let string = String(data: data, encoding: .utf8)
            let lines = string!.split(separator: "\n")
            for line in lines {
                let parts = line.split(separator: " ")
                switch parts[0] {
                case "v":
                    let x = Scalar(String(parts[1]))!
                    let y = Scalar(String(parts[2]))!
                    let z = Scalar(String(parts[3]))!
                    vertices.append(SIMD3<Scalar>(x, y, z))
                case "vn":
                    let x = Scalar(String(parts[1]))!
                    let y = Scalar(String(parts[2]))!
                    let z = Scalar(String(parts[3]))!
                    normals.append(SIMD3<Scalar>(x, y, z))
                case "f":
                    var face: [Int] = []
                    for part in parts[1...] {
                        let indices = part.split(separator: "/").map { Int($0)! - 1 }
                        face.append(indices[0])
                    }
                    faces.append(face)
                 case "vt":
                    let x = Scalar(String(parts[1]))!
                    let y = Scalar(String(parts[2]))!
                    uvs.append(SIMD2<Scalar>(x, y))
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
