#
# Cookbook Name:: drush
# Provider:: make
#
# Author:: Ben Clark <ben@benclark.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Support whyrun
def whyrun_supported?
  true
end

action :install do
  if @current_resource.exists
    Chef::Log.info("#{@new_resource}: Drupal install already exists - nothing to do.")
  else
    converge_by("Create #{@new_resource}") do
      Chef::Log.info("Running #{@new_resource} for #{@new_resource.makefile}")

      # Ensure the build_path directory is present.
      directory @new_resource.build_path do
        owner new_resource.shell_user
        group new_resource.shell_group
        mode "0755"
        recursive true
        action :create
      end

      # Execute the drush make command.
      drush_cmd "make" do
        arguments [ new_resource.makefile, "." ]

        drupal_root new_resource.build_path

        shell_user new_resource.shell_user
        shell_group new_resource.shell_group
        shell_timeout new_resource.shell_timeout
      end
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::DrushMake.new(@new_resource.name)
  @current_resource.build_path(@new_resource.build_path)
  if DrushHelper.drupal_present?(@current_resource.build_path)
    Chef::Log.debug("Drush found Drupal core at #{@current_resource.build_path}")
    @current_resource.exists = true
  else
    Chef::Log.debug("Drush could not find Drupal core at #{@current_resource.build_path}")
  end
  @current_resource
end
