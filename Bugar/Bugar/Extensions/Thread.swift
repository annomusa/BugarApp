//
//  Thread.swift
//  Bugar
//
//  Created by Anno Musa on 14/06/21.
//

import Foundation

func executeInMainThread(_ work: @escaping () -> Void) {
    if Thread.isMainThread {
        work()
    } else {
        DispatchQueue.main.async {
            work()
        }
    }
}
