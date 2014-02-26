Pod::Spec.new do |s|
  s.name         = "UnionFind"
  s.version      = "1.0.0"
  s.summary      = "A union find / disjoint set data structure."
  s.description  = <<-DESC
                   Supports efficiently determining if two objects belong to the same set,
                   and combining the sets two objects are in.
                   
                   * Give the object you want to belong to an (implicit) set a field of type UnionFindNode *.
                   * Initialize the node field with 'yourNodeField = [UnionFindNode new]' before doing operations on it.
                   * Use '[obj1.yourNodeField unionWith:obj2.yourNodeField]' to merge two objects' sets into a single set.
                   * Use '[obj1.yourNodeField isInSameSetAs:obj2.yourNodeField]' to determine if two objects are in the same set.
                   DESC
  s.homepage     = "https://github.com/Strilanc/UnionFind-ObjC"
  s.license      = { :type => 'Unlicense', :file => 'License.txt' }
  s.author       = { "Craig Gidney" => "craig.gidney@gmail.com" }
  s.source       = { :git => "https://github.com/Strilanc/UnionFind-ObjC.git", :tag => "v1.0.0" }
  s.source_files  = 'src', 'src/**/*.{h,m}'
  s.requires_arc = true
end
