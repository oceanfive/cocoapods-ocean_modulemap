module Pod
  class Command
    # This is an example of a cocoapods plugin adding a top-level subcommand
    # to the 'pod' command.
    #
    # You can also create subcommands of existing or new commands. Say you
    # wanted to add a subcommand to `list` to show newly deprecated pods,
    # (e.g. `pod list deprecated`), there are a few things that would need
    # to change.
    #
    # - move this file to `lib/pod/command/list/deprecated.rb` and update
    #   the class to exist in the the Pod::Command::List namespace
    # - change this class to extend from `List` instead of `Command`. This
    #   tells the plugin system that it is a subcommand of `list`.
    # - edit `lib/cocoapods_plugins.rb` to require this file
    #
    # @todo Create a PR to add your plugin to CocoaPods/cocoapods.org
    #       in the `plugins.json` file, once your plugin is released.
    #
    class OceanModulemap < Command
      self.summary = 'generate modulemap file content'

      self.description = <<-DESC
        modulemap file generated
      DESC

      self.arguments = 'ocean-modulemap'

      def initialize(argv)
        # 获取参数
        @target_dir = argv.shift_argument
        super
      end

      def validate!
        super
        # help! 'A Pod name is required.' unless @name
      end

      def run
        # UI.puts "Add your implementation for the cocoapods-ocean_modulemap plugin in #{__FILE__}"

        # 找到pods目录进行 framework 文件中 modulemap 文件的生成

        # 最终的目录
        dir = fetch_final_dir
        # 文件夹校验
        unless File.directory?(dir)
          puts "#{dir} is not a valid directory !!\n"
          exit(1)
        end

        # 获取所有的 framework 路径
        framework_paths = find_all_framework_paths(dir)
        framework_paths.each do |path|
          handle_framework_modulemap(path)
        end
      end

      # 获取最终的文件夹目录
      # @return [String] 最终的文件夹目录
      def fetch_final_dir
        # 目标文件夹，默认是当前目录
        dir = Dir.pwd
        dir = @target_dir.to_s if @target_dir

        puts "\n you not set target dir, so use current dir (pwd) !!!\n" unless @target_dir
        puts 'final dir: ' + dir.to_s
        dir.to_s
      end

      # 查找指定目录内所有的 framework
      # @param dir 目录
      # @return [String] framework 的路径
      def find_all_framework_paths(dir = '')
        # 遍历所有的文件
        find_framework_cmd = 'find ' + dir.to_s
        find_framework_cmd += ' -name *.framework'
        find_framework_res = %x(#{find_framework_cmd})

        framework_paths = find_framework_res.to_s.split
        puts '-----'
        puts 'find framework path result: '
        puts framework_paths
        puts '-----'
        framework_paths
      end

      # 处理 framework 的 modulemap 文件
      # @param [String] path framework的路径
      def handle_framework_modulemap(path = '')
        puts "\nhandle_framework_modulemap at path: " + path.to_s

        name = File.basename(path)
        puts 'basename: ' + name.to_s
        framework_name = File.basename(path, '.framework')
        puts 'framework_name: ' + framework_name.to_s

        # /Modules 目录处理
        module_dir = path + '/Modules'
        puts 'module dir: ' + module_dir.to_s
        # 不存在则进行创建
        if File.exist?(module_dir)
          puts 'already exist !'
        else
          puts 'not exist, need mkdir !'
          FileUtils.mkdir_p(module_dir.to_s)
        end

        # modulemap 文件处理, module.modulemap
        modulemap_path = module_dir.to_s + '/module.modulemap'
        puts 'modulemap path: ' + modulemap_path.to_s

        if File.exist?(modulemap_path)
          puts 'already exist, need return, do nothings !'
        else
          puts 'not exist, need generate modulemap file !'

          # 从 Headers 目录中找到所有的 头文件
          headers_dir = path + '/Headers'
          framework_headers_paths = find_all_header_paths(headers_dir)
          # 普通的.h文件
          framework_normal_headers_paths = framework_headers_paths.reject do |header_path|
            header_path.to_s.include?('-umbrella.h')
          end
          # -umbrella.h 文件
          framework_umbrella_headers_paths = framework_headers_paths - framework_normal_headers_paths

          # 文件名称
          framework_normal_headers = map_basename(framework_normal_headers_paths)
          framework_umbrella_headers = map_basename(framework_umbrella_headers_paths)

          content = generate_moudulemap_content(framework_name, framework_umbrella_headers, framework_normal_headers)

          # 保存到文件中
          Pathname.new(modulemap_path.to_s).open('w') do |f|
            f.write(content)
          end
        end
      end

      # 查找所有的 headers(.h) 文件路径
      # @param dir 目录路径
      # @return 所有的头文件路径
      def find_all_header_paths(dir = '')
        # 遍历所有的文件
        framework_headers_cmd = 'find ' + dir.to_s
        framework_headers_cmd += ' -name *.h'
        framework_headers_res = %x(#{framework_headers_cmd})

        framework_headers_res.to_s.split
      end

      # 把路径映射为文件名称
      # @param paths 路径列表
      # @return names 文件名称列表
      def map_basename(paths = [])
        paths.map do |path|
          File.basename(path)
        end
      end

      # 根据头文件类型，生成在 moudulemap 中显示的内容
      # @param header 头文件
      # @return 生成的内容
      def generate_header_content(header = '')
        content = if header.include?('-umbrella.h')
                    'umbrella header ' + '"' + header.to_s + '"'
                  else
                    'header ' + '"' + header.to_s + '"'
                  end
        puts "header: #{header}, module map content: #{content}"
        content
      end

      # 生成 moudulemap 文件内容
      # @param framework_name framework 名称
      # @param umbrella_headers umbrella headers 文件名称列表
      # @param normal_headers normal headers 文件名称列表
      # @return 内容
      def generate_moudulemap_content(framework_name = '', umbrella_headers = [], normal_headers = [])

        # 生成 header 对应的内容
        normal_headers_contents = normal_headers.map do |header_path|
          generate_header_content(header_path)
        end
        umbrella_headers_contents = umbrella_headers.map do |header_path|
          generate_header_content(header_path)
        end

        # 生成 modulemap 文件内容
        content = <<-MODULE_MAP
framework module #{framework_name} {
  #{umbrella_headers_contents.join("\n  ")}
  #{normal_headers_contents.join("\n  ")}

  export *
  module * { export * }
}
        MODULE_MAP

        puts '\n generate_moudulemap_content result: '
        puts content

        content
      end
    end
  end
end
