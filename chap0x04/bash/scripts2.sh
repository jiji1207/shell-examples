#!/usr/bin/env bash


#统计不同年龄区间范围的球员的数量、百分比
function age_range 
{
    awk -F "\t" '
	BEGIN{a=0;b=0;c=0;}
	$6!="Age"{
		if($6>=0&&$6<20)
		{a++}
		else if($6>=20&&$6<=30)
		{b++}
		else
		{c++}
	}
	END{
		sum=a+b+c;
		printf("age under 20 player: number is %d\t percentage is %.3f%\n",a,a*100/sum);			
		printf("age between 20 to 30 player: number is %d\t percentage is %.3f%\n",b,b*100/sum);
		printf("age over 30 player: number is %d\t percentage is %.3f%\n",c,c*100/sum);
	}' worldcupplayerinfo.tsv
}


#统计不同场上位置的球员数量百分比

function position_range
{
    awk -F "\t" '
	BEGIN{sum=0}
	$5!="Position"{
		pos[$5]++;
		sum++;
	}
	END{
		printf(" Position\tCount\tPercentage\n");
		for(i in pos){
			printf("%13s\t%d\t%f%%\n",i,pos[i],pos[i]*100.0/sum);
		}
	}' worldcupplayerinfo.tsv
}


#统计名字最长的球员和名字最短的球员

function max_min_name
{
    awk -F "\t" '
	BEGIN{max_len=-1;min_len=1000;}
	$9!="Player"{
		len=length($9);
            	names[$9]=len;
            	max_len=len>max_len?len:max_len;
           	min_len=len<min_len?len:min_len;
	}
	END{
		for(i in names){
			if(names[i]==max_len){
			printf("The longest name is %s\n",i);
			}
			else if(names[i]==min_len){
			printf("The shortest name is %s\n",i);
			}
	}
	}' worldcupplayerinfo.tsv
}


#统计年龄最大和最小的球员

function max_min_age
{
    awk -F "\t" '
	BEGIN{max_age=-1;min_age=1000;}
	NR>1{
		age=$6;
		names[$9]=age;
		max_age=age>max_age?age:max_age;
		min_age=age<min_age?age:min_age;
	}
	END{
		printf("The oldest age is %d,his name is\n",max_age);
		for(i in names){
		if(names[i]==max_age){printf("%s\n",i);}
		}	
		printf("\n");
		printf("The youngest age is %d,his name is\n",min_age);
		for(i in names){
		if(names[i]==min_age){printf("%s\n",i);}
		}
	}' worldcupplayerinfo.tsv
}


#帮助文档

function help 
{
        echo "HELP INFO:"
        echo "===================================================================================="
        echo "-r       统计不同年龄区间的区间范围（20岁以下、20-30岁，30岁以上）的球员数量、百分比"
        echo "-p       统计不同场上位置的球员数量、百分比"
        echo "-n       统计名字最长的球员和名字最短的球员(字符数统计)"
        echo "-a       统计年龄最大和最小的球员"
        echo "-h                    帮助文档"
}


while [ "$1" != "" ];
do
case "$1" in
            "-r") 
		age_range 
		exit 0
		;;
            "-p")
		position_range 
		exit 0
		;;
            "-n")
		max_min_name 
		exit 0
		;;
            "-a")
		max_min_age 
		exit 0
		;;
            "-h")
                help 
		exit 0
		;;
        esac
    done
