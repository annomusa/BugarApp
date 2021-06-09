//
//  URLSession+Request.swift
//  Bugar
//
//  Created by Anno Musa on 09/06/21.
//

import Foundation

extension URLSession {
    
    @discardableResult
    func call<Model>(
        request: Request<Model>,
        onComplete: @escaping (Result<Model, Error>) -> ()
    ) -> URLSessionDataTask {
        let req = request.request
        let task = dataTask(with: req) { data, response, error in
            
            if let error = error {
                onComplete(.failure(error))
                return
            }
            
            guard let resp = response as? HTTPURLResponse else {
                onComplete(.failure(UnknownError()))
                return
            }
            
            guard request.successStatusCode(resp.statusCode) else {
                onComplete(.failure(
                    UnacceptableStatusCodeError(
                        statusCode: resp.statusCode,
                        response: resp,
                        responseBody: data
                    )
                ))
                return
            }
            
            onComplete(request.parser(data, resp))
        }
        task.resume()
        return task
    }
    
}
