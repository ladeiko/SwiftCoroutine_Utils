Pod::Spec.new do |s|
    s.name = 'SwiftCoroutine_Utils'
    s.version = '1.0.0'
    s.summary = 'Some useful extensions for SwiftCoroutine library (https://github.com/belozierov/SwiftCoroutine)'
    s.homepage = 'https://github.com/ladeiko/SwiftCoroutine_Utils'
    s.license = { :type => 'CUSTOM', :file => 'LICENSE' }
    s.author = { 'Siarhei Ladzeika' => 'sergey.ladeiko@gmail.com' }
    s.source = { :git => 'https://github.com/ladeiko/SwiftCoroutine_Utils.git', :tag => "#{s.version}" }
    s.requires_arc = true
    s.swift_versions = '4.0', '4.2', '5.0', '5.1', '5.2', '5.3'
    s.ios.deployment_target = '10.0'
    s.osx.deployment_target = '10.12'

    s.subspec 'CoFuture' do |s|
        s.source_files = 'Source/CoFuture/*.swift'
        s.dependency    'SwiftCoroutine'
    end

    s.subspec 'OperationQueue' do |s|
        s.source_files = 'Source/OperationQueue/*.swift'
        s.dependency    'SwiftCoroutine'
    end
end
