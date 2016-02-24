#!/usr/bin/python
# -*- coding:utf-8 -*-

# xctool -workspace "Jackpot.xcworkspace" -scheme "Jackpot" -configuration "Release" -sdk "iphoneos" CODE_SIGN_IDENTITY="iPhone Distribution: hangzhou dacaiwangluokeji Co.,Ltd. (BLU32697WN)" archive -archivePath "/Users/wufan/Desktop/archive"

import os
import time
import biplist
#from biplist import *


class IPABuilder:
    def __init__(self):
        # 原始 builder number
        self.old_bn = 0
        # 当前 builder number
        self.cur_bn = 0

        # 项目路径
        self.project_path = ''

        # 输出文件前缀, '20151020_v5.0_501'
        self.prefix_name = ''

        # 输出文件路径
        self.output_path = ''
        self.archive_path = ''

        # 清空命令, 编译命令
        self.clean_cmd = ''
        self.build_cmd = ''

        # plist 文件路径
        self.project_info_path = ''
        self.watchapp_info_path = ''
        self.watchext_info_path = ''

        self.scheme = ''
        pass

    # 编译 xcarchive 文件
    def archive(self):
        # 获取当前工作目录
        cwd = os.getcwd()

        try:
            # 切换到project目录
            os.chdir(self.project_path)

            # 清空工程
            if os.system(self.clean_cmd):
                print('清理失败...')
                return False

            # 编译工程
            if os.system(self.build_cmd):
                print('编译失败...')
                return False
        except Exception, e:
            print 'error: %s' % e
            pass
        finally:
            # 还原工作目录
            os.chdir(cwd)

        return True

    # 打包成 IPA
    def export(self):
        pass

    def modify_bundle_number(self, number):
        number_str = str(number)
        os.system('/usr/libexec/PlistBuddy -c "Set:CFBundleVersion %s" "%s"' % (number_str, self.project_info_path))
        os.system('/usr/libexec/PlistBuddy -c "Set:CFBundleVersion %s" "%s"' % (number_str, self.watchapp_info_path))
        os.system('/usr/libexec/PlistBuddy -c "Set:CFBundleVersion %s" "%s"' % (number_str, self.watchext_info_path))
        pass

    def start(self):
        # 修改版本号
        self.modify_bundle_number(self.cur_bn)
        if not self.archive():
            self.modify_bundle_number(self.old_bn)
            return False

        self.export()
        return True


class BuilderConfigure:
    def __init__(self):
        # 编译参数, workspace 和 project 二选一
        self.sdk = 'iphoneos'
        self.configuration = 'Release'
        self.sign = ''
        self.scheme = ''
        self.workspace = ''
        self.project = ''
        self.archive_path = ''

        # 原始 builder number
        self.old_bn = 0
        # 当前 builder number
        self.cur_bn = 0

        # 项目路径
        self.project_path = ''

        # info.plist 文件路径
        self.project_info_path = ''
        self.watchapp_info_path = ''
        self.watchext_info_path = ''

        # 编译时中间文件路径
        # self.build_path = ''

        # 输出路径
        self.output_path = ''

        # 输出文件前缀, '20151020_v5.0_501'
        self.prefix_name = ''

        # 清空命令, 编译命令
        self.clean_cmd = ''
        self.build_cmd = ''

        # 编译时间
        self.build_date = ''

        #
        self.adhoc_profile = ''
        self.appstore_profile = ''

    # 检查参数
    def verify_parameter(self):
        if len(self.sign) == 0:
            print('sign can not be null.')
            return False

        if len(self.workspace) == 0 and len(self.project) == 0:
            print('workspace or project can not be null.')
            return False

        if len(self.scheme) == 0:
            print('scheme can not be null.')
            return False
        return True

    # 序列化命令参数
    def serialize_cmd(self, parameter_kvs):
        parameter_list = []

        for (key, value) in parameter_kvs.items():
            # 空格连接
            if key.startswith('-'):
                parameter_list.append(key + ' ' + '"' + value + '"')
            # 等号连接
            else:
                parameter_list.append(key + '=' + '"' + value + '"')

        return ' '.join(parameter_list)

    # 生成项目配置
    def init_configure(self):
        # 读取配置文件, 实现 Build Number + 1
        project_info = biplist.readPlist(self.project_info_path)

        version = project_info['CFBundleShortVersionString']
        build_number = project_info['CFBundleVersion']
        day_time = time.strftime('%Y%m%d')

        self.build_date = day_time
        self.old_bn = int(build_number)
        # 如果外部没有指定版本号，则进行自增
        if self.cur_bn == 0:
            self.cur_bn = self.old_bn + 1

        # 输出目录名
        self.prefix_name = '%s_v%s_%d' % (day_time, version, self.cur_bn)

    # 生成编译命令
    def generate_cmd_line(self):
        # 清空工程命令
        parameter_kvs = {
            # '-workspace': self.workspace,
            '-scheme': self.scheme,
            '-configuration': self.configuration,
            '-sdk': self.sdk
        }
        if len(self.workspace):
            parameter_kvs['-workspace'] = self.workspace
        else:
            parameter_kvs['-project'] = self.project

        min_time = time.strftime('%H%M')

        self.clean_cmd = 'xctool %s clean' % self.serialize_cmd(parameter_kvs)

        self.output_path = os.path.join(self.output_path, self.prefix_name)
        self.archive_path = os.path.join(self.output_path, '%s_%s.xcarchive' % (self.scheme, min_time))

        # 编译工程命令
        parameter_kvs = {
            # '-workspace': self.workspace,
            '-scheme': self.scheme,
            '-configuration': self.configuration,
            '-sdk': self.sdk,
            # '-archivePath': archive_path,
            'CODE_SIGN_IDENTITY': self.sign
        }
        if len(self.workspace):
            parameter_kvs['-workspace'] = self.workspace
        else:
            parameter_kvs['-project'] = self.project

        self.build_cmd = 'xctool %s archive -archivePath "%s"' % (self.serialize_cmd(parameter_kvs), self.archive_path)

    def ipa_builder(self):
        if not self.verify_parameter():
            return None

        self.init_configure()
        self.generate_cmd_line()

        builder = IPABuilder()
        builder.project_path = self.project_path
        builder.build_cmd = self.build_cmd
        builder.clean_cmd = self.clean_cmd
        builder.cur_bn = self.cur_bn
        builder.old_bn = self.old_bn
        builder.project_info_path = self.project_info_path
        builder.watchapp_info_path = self.watchapp_info_path
        builder.watchext_info_path = self.watchext_info_path
        builder.archive_path = self.archive_path
        builder.output_path = self.output_path
        builder.scheme = self.scheme
        return builder

print 'a'

if __name__ == '__main__':
    builder_configure = BuilderConfigure()
    
    # 证书，工程名称
    builder_configure.sign = 'iPhone Distribution: hangzhou dacaiwangluokeji Co.,Ltd. (BLU32697WN)'
    builder_configure.scheme = 'Jackpot'
    builder_configure.workspace = 'Jackpot.xcworkspace'

#    # 项目路径
#    builder_configure.project_path = '/Users/wufan/Workspace/git/Jackpot'
#
#    # info.plist 文件路径
#    builder_configure.project_info_path = '/Users/wufan/Workspace/git/Jackpot/Jackpot/Supporting Files/Info.plist'
#    builder_configure.watchapp_info_path = '/Users/wufan/Workspace/git/Jackpot/Jackpot WatchKit App/Info.plist'
#    builder_configure.watchext_info_path = '/Users/wufan/Workspace/git/Jackpot/Jackpot WatchKit Extension/Info.plist'
#
#    # 输出路径
#    builder_configure.output_path = '/Users/wufan/Workspace/package'
#    builder_configure.output_path = '/Users/wufan/Library/Developer/Xcode/Archives'
    # 项目路径
    builder_configure.project_path = '/Users/ray/Desktop/Dacai.iOS'
    
    # info.plist 文件路径
    builder_configure.project_info_path = '/Users/ray/Desktop/Dacai.iOS/Jackpot/Supporting Files/Info.plist'
    builder_configure.watchapp_info_path = '/Users/ray/Desktop/Dacai.iOS/Jackpot WatchKit App/Info.plist'
    builder_configure.watchext_info_path = '/Users/ray/Desktop/Dacai.iOS/Jackpot WatchKit Extension/Info.plist'
    # 输出路径
    builder_configure.output_path = '/Users/ray/Desktop/archive'
    builder_configure.output_path = '/Users/ray/Desktop/archive'


    # 指定内部版本号
    builder_configure.cur_bn = 514
    # 组装
    ipa_builder = builder_configure.ipa_builder()
    ipa_builder.start()
