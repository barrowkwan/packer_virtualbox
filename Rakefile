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
  
	task :default do

    Rake::Task["vm_image_builder:cleanup"].invoke
    Rake::Task["vm_image_builder:init"].invoke
    
    vm_config = load_vm_config

    vm_type = ENV['VM_TYPE'].nil? ? "" : ENV['VM_TYPE']    
    vm_distro_version = ENV['VERSION'].nil? ? "" : ENV['VERSION']
    vm_target = ENV['TARGET'].nil? ? "" : ENV['TARGET']
    
    if ( vm_type.empty? || vm_distro_version.empty? || vm_target.empty? )
      raise "TARGET / VM_TYPE / VERSION are required"
    end

    iso_url = (!vm_config[vm_target].nil? && !vm_config[vm_target][vm_distro_version].nil? && !vm_config[vm_target][vm_distro_version]['iso_url'].nil?) ?
      vm_config[vm_target][vm_distro_version]['iso_url'] : ""
    distro_url = (!vm_config[vm_target].nil? && !vm_config[vm_target][vm_distro_version].nil? && !vm_config[vm_target][vm_distro_version]['url'].nil?) ?
        vm_config[vm_target][vm_distro_version]['url'] : ""
    iso_checksum = (!vm_config[vm_target].nil? && !vm_config[vm_target][vm_distro_version].nil? && !vm_config[vm_target][vm_distro_version]['iso_checksum'].nil?) ?
      vm_config[vm_target][vm_distro_version]['iso_checksum'] : ""
    iso_checksum_type = (!vm_config[vm_target].nil? && !vm_config[vm_target][vm_distro_version].nil? && !vm_config[vm_target][vm_distro_version]['iso_checksum_type'].nil?) ?
      vm_config[vm_target][vm_distro_version]['iso_checksum_type'] : ""
    output_image_name = "#{vm_target}-#{vm_distro_version}.box"
    vm_name = "packer-#{vm_target}-#{vm_distro_version}"
    provisioner_scripts = case vm_type
    when 'virtualbox-iso'
      (!vm_config['virtualbox-iso'].nil? && !vm_config['virtualbox-iso']['provisioner_scripts'].nil? && !vm_config['virtualbox-iso']['provisioner_scripts'][vm_target].nil?) ?
         vm_config['virtualbox-iso']['provisioner_scripts'][vm_target].map!{|p_script| "#{vm_target}#{vm_distro_version.split(".")[0]}-#{p_script}.sh"} :
         []
    else
      []    
    end
    
    case vm_target
    when 'centos'
      puts "Building CentOS VM"
      guest_os_type = 'RedHat_64'
      boot_command = [
  			"<wait><esc><esc>",
  			"linux ks=http://{{.HTTPIP}}:{{.HTTPPort}}/packer.cfg biosdevname=0 net.ifnames=0",
  			"<enter>"
      ]
      shutdown_command = "sudo -S shutdown -P now"
      
    when 'ubuntu'
      puts "Building Ubuntu VM"
      guest_os_type = 'Ubuntu_64'
      boot_command = [
        "<esc><esc><enter><wait>",
        "/install/vmlinuz noapic ",
        "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/packer.cfg ",
        "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ",
        "hostname=ubuntu-#{vm_distro_version} ",
        "fb=false debconf/frontend=noninteractive ",
        "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA ",
        "keyboard-configuration/variant=USA console-setup/ask_detect=false ",
        "initrd=/install/initrd.gz -- <enter>"
      ]
      shutdown_command = "echo #{(!vm_config['vm_image_builder'].nil? && !vm_config['vm_image_builder']['ssh_password'].nil?) ? vm_config['vm_image_builder']['ssh_password'] : 'vagrant'}| sudo -S shutdown -P now"

 
    else
      raise "Nothing to build"
    end

    puts "Generate Kickstart/Preseed Script"
		render_template("#{File.dirname(__FILE__)}/template/kickstart/#{vm_target}.cfg.erb",
      "#{File.dirname(__FILE__)}/tmp/http/packer.cfg",
      binding)
    
    puts "Generate Packer Configuration"
		render_template("#{File.dirname(__FILE__)}/template/packer/packer.json.erb",
      "#{File.dirname(__FILE__)}/tmp/packer/packer.json",
      binding)

    puts "Packer start building VM"
    puts %x{packer build "#{File.dirname(__FILE__)}"/tmp/packer/packer.json}
    # Open3.popen3("packer build #{File.dirname(__FILE__)}/tmp/packer/packer.json") do |stdout, stderr, status, thread|
#       puts stdout.read
#     end
  end
  

end
