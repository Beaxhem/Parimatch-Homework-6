//
//  AuthManager.swift
//  Parimatch Homework 6
//
//  Created by Ilya Senchukov on 17.02.2021.
//

import KeychainAccess
import AuthenticationServices

class DefaultAuthManager: AuthManager {

    private let keychain = Keychain.authorizationService

    private let networkManager: NetworkManager = DefaultNetworkManager()

    func isLoggedIn() -> Bool {
        let accessToken = keychain.get(.accessToken)

        if let accessToken = accessToken {
            print(accessToken)
            return true
        }

        return false
    }

    func logout() {
        // No need to clear cookies, because ASWEbAuthenticationSession does it itself
        try? keychain.remove(KeychainKeys.accessToken.rawValue)
    }
}

extension DefaultAuthManager {
    func authorizeWithGithub(
        contextProvider: ContextProvidingViewController,
        completion: ((Error?) -> Void)?) {

        fetchAuthorizationCode(context: contextProvider) { [weak self] code in
            guard let code = code else {
                return
            }

            self?.fetchAccessToken(code: code) { [weak self] res in
                switch res {
                case .failure(let error):
                    print(error)
                    self?.keychain.set("error", key: .accessToken)
                    DispatchQueue.main.sync {
                        contextProvider.dismiss(animated: true, completion: nil)
                    }
                case .success(let accessToken):
                    self?.keychain.set(accessToken, key: .accessToken)
                    DispatchQueue.main.sync {
                        contextProvider.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }

    private func fetchAuthorizationCode(
        context: ASWebAuthenticationPresentationContextProviding,
        completion: @escaping (String?) -> Void) {

        guard var urlComponents = URLProvider.authorizationURL else {
            completion(nil)
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: GithubSecretsProvider.clientID),
            URLQueryItem(name: "scope", value: "repo")
        ]

        let scheme = "com.beaxhem.Parimatch-Homework-6"

        guard let url = urlComponents.url else {
            completion(nil)
            return
        }

        let session = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: scheme) { callbackURL, error in

            guard error == nil, let callbackURL = callbackURL else {
                print(error!)
                completion(nil)
                return
            }

            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            guard let code = queryItems?.filter({ $0.name == "code" }).first?.value else {
                return
            }

            completion(code)
        }

        session.prefersEphemeralWebBrowserSession = true
        session.presentationContextProvider = context
        session.start()
    }

    private func fetchAccessToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {

        guard var urlComponents = URLProvider.accessTokenURL else { return }

        urlComponents.queryItems = [
            .init(name: "client_id", value: GithubSecretsProvider.clientID),
            .init(name: "client_secret", value: GithubSecretsProvider.secret),
            .init(name: "code", value: code)
        ]

        guard let url = urlComponents.url else { return }

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        networkManager.dataTask(urlRequest: urlRequest) { (data, _, err) in
            guard err == nil, let data = data else {
                completion(.failure(err!))
                return
            }

            do {
                let credentials = try JSONDecoder().decode(Credentials.self, from: data)
                completion(.success(credentials.accessToken))
            } catch {
                completion(.failure(AuthError.wrongCredentials))
            }
        }
    }
}
