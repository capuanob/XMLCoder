#if canImport(Darwin)
import Darwin.C
#elseif canImport(Glibc)
import Glibc
#elseif canImport(MSVCRT)
import MSVCRT
#endif

import Foundation
import XMLCoder

struct Note: Codable {
    let to: String
    let from: String
    let heading: String
    let body: String
}

var ctr = 0

@_cdecl("LLVMFuzzerTestOneInput")
public func XMLFuzzer(_ start: UnsafeRawPointer, _ count: Int) -> CInt {
    let fdp = FuzzedDataProvider(start, count)
    ctr += 1

    do {
        try XMLDecoder().decode(Note.self, from: Data(fdp.ConsumeRemainingString().utf8))
    } catch _ as DecodingError {
        return -1
    } catch let e as NSError {
        if ctr >= 100_000 {
            exit(EXIT_FAILURE)
        }
    } catch let e {
        exit(EXIT_FAILURE)
    }
    return 0;
}