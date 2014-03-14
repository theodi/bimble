class Bimble::GitStrategy::GithubApi
  
  include Bimble::Helpers::Strings
  include Bimble::Helpers::Github
  
  def initialize(git_url, oauth_token)
    @git_url = git_url
    @oauth_token = oauth_token
  end

  def in_working_copy
    Dir.mktmpdir do |tmpdir|
      # Get files
      files = get_files("Gemfile.*").merge(get_files(".*gemspec"))
      Dir.chdir(tmpdir) do
        # Write files
        files.each_pair do |name, content|
          File.open(name, 'w') {|f| f.write(content) }
        end
        # Store md5 of lockfile
        @original_md5 = Digest::MD5.hexdigest(File.read("Gemfile.lock"))
        # Do the business
        yield
      end
    end
  end

  def get_files(name)
    blobs = blob_shas(default_branch, name)
    Hash[blobs.map{|x| [x[0], blob_content(x[1])]}]
  end
  
  def lock_md5
    Digest::MD5.hexdigest(File.read("Gemfile.lock"))
  end
  
  def lockfile_changed?
    lock_md5 != @original_md5
  end
  
  def get_file(name)
    get_files(name)[name]
  end
  
  def commit_to_new_branch
    commit_file("Gemfile.lock", File.read("Gemfile.lock"))
  end
  
  def commit_file(name, content)    
    blob_sha = create_blob(content)
    tree_sha = add_blob_to_tree(blob_sha, name)
    commit_sha = commit(tree_sha)
    create_branch(branch_name, commit_sha)
  end

end