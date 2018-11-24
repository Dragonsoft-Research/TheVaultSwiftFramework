
Pod::Spec.new do |s|

  s.name         = "TheVaultSwiftFramework"
  s.version      = "1.0.0"
  s.summary      = "A native wrapper for the Vault's REST API"

  s.description  = <<-DESC
                    The framework also supports Objective-C applications, and has a dependency on the SocketIOClient framework.
                   DESC

  s.homepage     = "https://github.com/Dragonsoft-Research/TheVaultSwiftFramework"
  s.license      = "MIT"
  s.author             = "World Quest International"

  s.platform     = :ios, "11.0"

  s.source       = { :git => "https://github.com/Dragonsoft-Research/TheVaultSwiftFramework.git", :commit => "6896146ebd56ef9189addbdcf84269d7e1ad6f86" }


  s.source_files  = "TheVaultFramework/**/*.{h,m}"
  s.dependency "Socket.IO-Client-Swift", "~> 13.3.0"

end
