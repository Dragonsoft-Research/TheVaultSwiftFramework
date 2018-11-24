
Pod::Spec.new do |s|

  s.name         = "TheVaultSwiftFramework"
  s.version      = "1.0.0"
  s.summary      = "A native wrapper for the Vault's REST API"
  s.description  = <<-DESC
                    The framework also supports Objective-C applications, and has a dependency on the SocketIOClient framework.
                   DESC
  s.homepage     = "https://github.com/Dragonsoft-Research/TheVaultSwiftFramework"
  s.license      = "MIT"
  s.author       = "World Quest International"
  s.platform     = :ios, "11.0"
  s.source       = { :git => "https://github.com/Dragonsoft-Research/TheVaultSwiftFramework.git", :tag => "1.0.0" }
  s.source_files  = "TheVaultFramework/**/*"
  s.dependency "Socket.IO-Client-Swift", "~> 13.3.0"
  s.swift_version = "4.2"

end
