#
# Copyright 2016
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
 
require 'erb'
require 'fileutils'
require 'yaml'
require 'open3'

def render_template(template, output, scope)
    tmpl = File.read(template)
    erb = ERB.new(tmpl, 0, "<>")
    File.open(output, "w") do |f|
        f.puts erb.result(scope)
    end
end
    
def load_vm_config
  if File.exists? "vm_config.yaml"
    YAML.load_file("vm_config.yaml")
  end
end

namespace :vm_image_builder do

	task :init do
    vm_config = load_vm_config
    FileUtils.mkdir_p "#{File.dirname(__FILE__)}/tmp"
    FileUtils.mkdir_p "#{File.dirname(__FILE__)}/tmp/http"
    FileUtils.mkdir_p "#{File.dirname(__FILE__)}/tmp/packer"
	end

	task :cleanup do
    vm_config = load_vm_config
    FileUtils.rm_rf Dir.glob("#{File.dirname(__FILE__)}/tmp/*")
	end
  
	task :default, [:arg1, :arg2, :arg3] do |t, args|
    Rake::Task["vm_image_builder:cleanup"].invoke
    Rake::Task["vm_image_builder:init"].invoke
    case args[:arg1]
    when 'centos'
      puts "Building CentOS VM"
      Rake::Task["vm_image_builder:centos_vm"].invoke(args[:arg2],args[:arg3])
    else
      puts "Nothing to build"
    end
  end
  

	task :centos_vm, [:arg1, :arg2] do |t, args|

    vm_config = load_vm_config
    vm_type = args[:arg2]
    vm_distro_version = args[:arg1]
    guest_os_type = 'RedHat_64'
    iso_url = vm_config['centos'][vm_distro_version]['iso_url']
    iso_checksum = vm_config['centos'][vm_distro_version]['iso_checksum']
    iso_checksum_type = vm_config['centos'][vm_distro_version]['iso_checksum_type']
    output_image_name = "centos-#{vm_distro_version}.box"

    provisioner_scripts = case vm_type
    when 'virtualbox-iso'
      (!vm_config['virtualbox-iso'].nil? && !vm_config['virtualbox-iso']['provisioner_scripts'].nil?) ?
         vm_config['virtualbox-iso']['provisioner_scripts'].map!{|p_script| "rhel#{vm_distro_version.split(".")[0]}-#{p_script}.sh"} :
         []
    else
      []    
    end
    
    puts "Generate Kickstart Script"
		render_template("#{File.dirname(__FILE__)}/template/kickstart/centos#{vm_distro_version.split('.')[0]}.cfg.erb",
      "#{File.dirname(__FILE__)}/tmp/http/ks.cfg",
      binding)
    
    puts "Generate Packer Configuration"
		render_template("#{File.dirname(__FILE__)}/template/packer/centos#{vm_distro_version.split('.')[0]}.json.erb",
      "#{File.dirname(__FILE__)}/tmp/packer/centos#{vm_distro_version.split('.')[0]}.json",
      binding)

    puts "Packer start building VM"
    puts %x{packer build "#{File.dirname(__FILE__)}"/tmp/packer/centos"#{vm_distro_version.split('.')[0]}".json}


	end

end
