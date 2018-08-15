package com.zucc.demo.controller;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class Recommend {
    public static double getSimilarDegree(String[] strArray1, String[] strArray2)
    {
        Map<String, double[]> vectorSpace = new HashMap<String, double[]>();
        double[] itemCountArray = null;

        for(int i=0; i<strArray1.length; ++i)
        {
            if(vectorSpace.containsKey(strArray1[i])){
                vectorSpace.get(strArray1[i])[0] = 0.1*(10-i);
            }
            else
            {
                itemCountArray = new double[2];
                itemCountArray[0] = 0.1*(10-i);
                itemCountArray[1] = 0;
                vectorSpace.put(strArray1[i], itemCountArray);
            }
        }

        for(int i=0; i<strArray2.length; ++i)
        {
            if(vectorSpace.containsKey(strArray2[i])) {
                vectorSpace.get(strArray2[i])[1] = 0.1*(10-i);
            }
            else
            {
                itemCountArray = new double[2];
                itemCountArray[0] = 0;
                itemCountArray[1] = 0.1*(10-i);
                vectorSpace.put(strArray2[i], itemCountArray);
            }
        }

        double vector1Modulo = 0.00;
        double vector2Modulo = 0.00;
        double vectorProduct = 0.00;
        Iterator iter = vectorSpace.entrySet().iterator();

        while(iter.hasNext())
        {
            Map.Entry entry = (Map.Entry)iter.next();
            itemCountArray = (double[])entry.getValue();

            vector1Modulo += itemCountArray[0]*itemCountArray[0];
            vector2Modulo += itemCountArray[1]*itemCountArray[1];

            vectorProduct += itemCountArray[0]*itemCountArray[1];
        }

        vector1Modulo = Math.sqrt(vector1Modulo);
        vector2Modulo = Math.sqrt(vector2Modulo);

        return (vectorProduct/(vector1Modulo*vector2Modulo));
    }
    public static double getLevenshtein(String[] str1, String[] str2) {
        // 计算两个字符串的长度。
        int len1 = str1.length;
        int len2 = str2.length;
        // 建立上面说的数组，比字符长度大一个空间
        int[][] dif = new int[len1 + 1][len2 + 1];
        // 赋初值，步骤B。
        for (int a = 0; a <= len1; a++) {
            dif[a][0] = a;
        }
        for (int a = 0; a <= len2; a++) {
            dif[0][a] = a;
        }
        // 计算两个字符是否一样，计算左上的值
        int temp;
        for (int i = 1; i <= len1; i++) {
            for (int j = 1; j <= len2; j++) {
                if (str1[i - 1].equals(str2[j - 1])) {
                    temp = 0;
                } else {
                    temp = 1;
                }
                // 取三个值中最小的
                dif[i][j] = min(dif[i - 1][j - 1] + temp, dif[i][j - 1] + 1, dif[i - 1][j] + 1);

            }
        }
        // 取数组右下角的值，同样不同位置代表不同字符串的比较
        // System.out.println("差异步骤：" + dif[len1][len2]);
        // 计算相似度
        double similarity = 1 - (double) dif[len1][len2] / Math.max(str1.length, str2.length);

        return similarity;
    }

    private static int min(int a, int b, int c) {
        int min = a < b ? a : b;
        return min < c ? min : c;
    }
    //两个字符串的编辑距离
    public static int Levenshtein(String A, String B) {
        if(A.equals(B)) {
            return 0;
        }
        //dp[i][j]表示源串A位置i到目标串B位置j处最低需要操作的次数
        int[][] dp = new int[A.length() + 1][B.length() + 1];
        for(int i = 1;i <= A.length();i++)
            dp[i][0] = i;
        for(int j = 1;j <= B.length();j++)
            dp[0][j] = j;
        for(int i = 1;i <= A.length();i++) {
            for(int j = 1;j <= B.length();j++) {
                if(A.charAt(i - 1) == B.charAt(j - 1))
                    dp[i][j] = dp[i - 1][j - 1];
                else {
                    dp[i][j] = Math.min(dp[i - 1][j] + 1,
                            Math.min(dp[i][j - 1] + 1, dp[i - 1][j - 1] + 1));
                }
            }
        }
        return dp[A.length()][B.length()];
    }
}
