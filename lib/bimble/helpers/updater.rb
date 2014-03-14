module Bimble::Helpers::Updater
  
  def update
    in_working_copy do
      Bimble.bundle_update
      if lockfile_changed?
        commit_to_new_branch
        @pr = open_pr(branch_name, default_branch) if @oauth_token
      end
    end
    @pr ? @pr['html_url'] : nil
  end

end