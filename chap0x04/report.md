# 实验四 shell脚本编程练习基础
---
## 实验要求
* **继承第一章：Linux基础（实验）的所有实验报告要求**
* **上述任务的所有源代码文件必须单独提交并提供详细的–help脚本内置帮助信息**
* **任务二的所有统计数据结果要求写入独立实验报告**
---
## 实验内容
* **任务一:用bash编写一个图片批处理脚本,实现以下功能:**
- [X] 支持命令行参数方式使用不同功能
- [X] 支持对指定目录下所有支持格式的图片文件进行批处理
- [X] 支持以下常见图片批处理功能的单独使用或组合使用
    * 支持对jpeg格式图片进行图片质量压缩
    * 支持对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
    * 支持对图片批量添加自定义文本水印
    * 支持批量重命名(统一添加文件名前缀或后缀,不影响原始文件扩展名)
    * 支持将png/svg图片统一转换为jpg格式图片

* **任务二:用bash编写一个文本批处理脚本,对以下附件分别进行批量处理完成相应的数据统计任务:**
- [X] 统计不同年龄区间范围(20岁以下、[20-30]、30岁以上)的球员数量、百分比
- [X] 统计不同场上位置的球员数量、百分比
- [X] 名字最长的球员是谁?名字最短的球员是谁?
- [X] 年龄最大的球员是谁?年龄最小的球员是谁?
  

* **任务二:用bash编写一个文本批处理脚本,对以下附件分别进行批量处理完成相应的数据统计任务:**
- [X] 统计访问来源主机TOP100和分别对应出现的总次数
- [X] 统计访问来源主机TOP100P和分别对应出现的总次数
- [X] 统计最频繁被访问的 URL TOP100
- [X] 统计不同响应状态码的出现次数和对应百分比
- [X] 分别统计不同4XX状态码对应的TOP10URL和对应出现的总次数
- [X] 给定URL输出TOP100访问来源主机
---
## 实验过程
* 任务一
    首先安装`ImageMagick`，用来处理图片文件；
    ```bash
    sudo apt-get install ImageMagick
    ```
    接着把需要处理的图片文件复制到虚拟机；
    然后创建脚本`scripts.sh`，按照任务一的要求编写脚本。

<br>

* 任务二
    创建任务二的脚本`scripts2.sh`；
    将需要处理的文件下载至本地。
    ```bash
    wget "https://c4pr1c3.gitee.io/linuxsysadmin/exp/chap0x04/worldcupplayerinfo.tsv"
    ```

<br>

* 任务三
    创建任务三的脚本`scripts3.sh`；
    将需要处理的文件下载至本地；
    ```bash
    wget "https://c4pr1c3.gitee.io/linuxsysadmin/exp/chap0x04/worldcupplayerinfo.tsv"
    ```
    并解压该文件。

<br>

---
## 遇到的问题及解决办法

* 脚本scripts.sh遇到的一些问题
  * 遇到问题1：安装`Imagemagick`后执行脚本`scripts.sh`会发现出现报错`bash:ls:command not found`并且Imagemagick中的工具`convert``rm`等也都会出现相同的报错。

    解决办法：在搜索引擎上查询问题，发现可能是命令的环境变量出现了问题，查询当前命令的环境变量，发现'convert'等命令并不在PATH环境变量中，需要将它们的路径添加至PATH，参考文章[linux可执行文件添加到PATH环境变量的方法](https://www.cnblogs.com/joshua317/p/6899057.html)
    ```bash
        #export PATH=/usr/local/bin:$PATH
    ```
    再次执行scripts.sh脚本，不再出现以上的报错。

  * 遇到的问题2:在本地执行脚本scripts.sh时，我将我的图片文件的绝对路径添加至脚本中
    ```bash
    file_path=/.../.../.../ # 我的文件的绝对路径
    cd $file_path
    ```
    然后在本地执行该脚本没有出现任何问题，但是我把scripts.sh部署到travis.ci上面是，一直提示在`shellcheck scripts.sh exited with 1`，再在本地执行`shellcheck scripts.sh`查看详情，发现在报错的提示信息中显示`^-----------^ SC2164 (warning): Use 'cd ... || exit' or 'cd ... || return' in case cd fails.`，我的理解就是cd 不可使用。

    解决办法：根据文章[shell脚本中无法使用cd的问题原因及解决方法](https://blog.csdn.net/GX_1_11_real/article/details/80990250)，我把原来的语句换成了
    ```bash
    source /.../.../...
    ```
    但是依旧不行，在shellcheck中依旧显示语法错误，我仔细一想，把文件部署到travis.ci的话我本地的路径是无法正常使用的，我应该使用相对路径才行，根据我上传到仓库的目录
    ![](report_pics/仓库目录1.png)
    ![](report_pics/仓库目录2.png)
    因为我在yaml文件中首先`cd chap0x04`然后`cd bash`才可以执行我的脚本，那此时我需要处理的图片的文件夹是相对处于上一级，那我只需要`source ../test_pics`即可，但是结果显示好像依旧不行。
    仔细一想其实可以把这个想法在yaml配置问价里实现，只需要把`cd chap0x04`改成`cd test_pics`然后执行脚本时，把`bash scripts,sh`改成`bash ../bash/scripts.sh`，问题解决。

  * 遇到的问题3:在travis上执行scripts脚本时，其他的要求都能实现，唯独添加水印的时候出现了报错，显示`unable to read font (null)@ error/annotate.c/RenderFreetype/1120` 

    解决办法：查询该报错，找到文档[unable to read font (null)](https://legacy.imagemagick.org/discourse-server/viewtopic.php?p=82055&sid=ad29ab4258114ba1c578f162cb458a70#p82055)，发现是需要我再安装一个叫`ghostscripts`的软件，安装之后，可以成功添加水印。

<br>

* 脚本scripts2.sh遇到的一些问题
    * 遇到的问题1:在travis上执行完脚本后发现执行脚本1时没有任何问题，但是执行脚本2时就会报错，显示的是`找不到该目录或文件`。
        
        解决办法：因为之处理scripts.sh脚本的原因，所以我是进入了test_pics目录下，而scripts2.sh脚本并不处于当前目录，所以需要再执行命令`cd ../bash/`才能进入到scripts2.sh脚本所在的目录。

<br>

* yaml配置文件以及部署travis-ci时遇到的问题

    * 遇到的问题1：写好三个脚本以及yaml文件后部署到travis-ci网站上，却一直无法没有执行任务，手动触发后出现了如下的报错，显示`could not parse`
    ![](report_pics/报错.jpeg)
    
        解决办法：在网上检索无果后，询问助教师姐，师姐给我发了一篇参考帖子[Could not parse the repo from github](https://travis-ci.community/t/could-not-parse-the-repo-from-github/6429)，根据文章里的指示和师姐的知道，我去到了这个网站<http://www.yamllint.com>对我的yaml文件的语法进行检查，发现很多地方的锁进是有问题的，修改之后再部署到travis-ci.com，可以看到我的任务开始执行。

<br>

---
## 参考资料
[shell 批量压缩指定目录及子目录内图片](https://blog.csdn.net/fdipzone/article/details/39651709)

[Imagemagick](https://imagemagick.org)

[linux可执行文件添加到PATH环境变量的方法](https://www.cnblogs.com/joshua317/p/6899057.html)

[shell脚本中无法使用cd的问题原因及解决方法](https://blog.csdn.net/GX_1_11_real/article/details/80990250)

[使用shell脚本统计文件中ip出现的次数](https://blog.csdn.net/xiamoyanyulrq/article/details/81570652)
[Shell awk命令详解（格式+使用方法](http://c.biancheng.net/view/992.html)

[unable to read font (null)](https://legacy.imagemagick.org/discourse-server/viewtopic.php?p=82055&sid=ad29ab4258114ba1c578f162cb458a70#p82055)

[Could not parse the repo from github](https://travis-ci.community/t/could-not-parse-the-repo-from-github/6429)

[Yaml Lint](http://www.yamllint.com)


