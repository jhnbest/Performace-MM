<template>
  <div :id="id" :style="{height:height,width:width}"></div>
</template>

<script>
  import echarts from 'echarts'
  import resize from '@/components/Chart/mixins/resize'
  export default {
    mixins: [resize],
    data () {
      return {
        chart: null
      }
    },
    mounted () {
      this.initChart()
    },
    beforeDestroy () {
      if (!this.chart) {
        return
      }
      this.chart.dispose()
      this.chart = null
    },
    methods: {
      initChart () {
        this.chart = echarts.init(document.getElementById(this.id))
        const xData = (function () {
          const data = []
          for (let i = 1; i < 13; i++) {
            data.push(i + '月')
          }
          return data
        }())
        this.chart.setOption({
          backgroundColor: '#344b58',
          title: {
            text: this.title,
            x: '20',
            top: '20',
            textStyle: {
              color: '#fff',
              fontSize: '22'
            },
            subtextStyle: {
              color: '#90979c',
              fontSize: '16'
            }
          },
          tooltip: {
            trigger: 'axis',
            axisPointer: {
              textStyle: {
                color: '#fff'
              }
            }
          },
          grid: {
            left: '5%',
            right: '5%',
            borderWidth: 0,
            top: 150,
            bottom: 95,
            textStyle: {
              color: '#fff'
            }
          },
          legend: {
            x: '5%',
            top: '10%',
            textStyle: {
              color: '#90979c'
            },
            data: ['预计工时', '总进度']
          },
          calculable: true,
          xAxis: [{
            type: 'category',
            axisLine: {
              lineStyle: {
                color: '#90979c'
              }
            },
            splitLine: {
              show: false
            },
            axisTick: {
              show: false
            },
            splitArea: {
              show: false
            },
            axisLabel: {
              interval: 0

            },
            data: xData
          }],
          yAxis: [{
            type: 'value', // value: 连续数据; category: 离散数据; time: 时间轴; log: 对数轴
            splitLine: { // 坐标轴在grid中的分割线
              show: false
            },
            axisLine: { // 坐标轴轴线相关
              lineStyle: {
                color: '#90979c'
              }
            },
            axisTick: { // 坐标轴刻度相关
              show: true
            },
            axisLabel: { // 坐标轴刻度标签
              interval: 'auto'
            },
            splitArea: { // 坐标轴在grid区域中的分隔区域
              show: false
            }
          }, {
            type: 'value', // value: 连续数据; category: 离散数据; time: 时间轴; log: 对数轴
            splitLine: { // 坐标轴在grid中的分割线
              show: false
            },
            axisLine: { // 坐标轴轴线相关
              lineStyle: {
                color: '#90979c'
              }
            },
            axisTick: { // 坐标轴刻度相关
              show: true
            },
            axisLabel: { // 坐标轴刻度标签
              interval: 'auto'
            },
            splitArea: { // 坐标轴在grid区域中的分隔区域
              show: false
            }
          }],
          dataZoom: [{
            show: true,
            height: 30,
            xAxisIndex: [0],
            bottom: 30,
            start: 10,
            end: 80,
            handleIcon: 'path://M306.1,413c0,2.2-1.8,4-4,4h-59.8c-2.2,0-4-1.8-4-4V200.8c0-2.2,1.8-4,4-4h59.8c2.2,0,4,1.8,4,4V413z',
            handleSize: '110%',
            handleStyle: {
              color: '#d3dee5'
            },
            textStyle: {
              color: '#fff'
            },
            borderColor: '#90979c'
          }, {
            type: 'inside',
            show: true,
            height: 15,
            start: 1,
            end: 35
          }],
          series: [{
            name: '预计工时',
            type: 'bar',
            stack: 'total',
            itemStyle: {
              normal: {
                color: 'rgba(0,191,183,1)',
                barBorderRadius: 0,
                label: {
                  show: true,
                  position: 'top',
                  formatter (p) {
                    return p.value > 0 ? p.value : ''
                  }
                }
              }
            },
            data: [],
            yAxisIndex: 0
          }, {
            name: '总进度',
            type: 'line',
            symbolSize: 10,
            symbol: 'circle',
            itemStyle: {
              normal: {
                color: 'rgba(252,230,48,1)',
                barBorderRadius: 0,
                label: {
                  show: true,
                  position: 'top',
                  formatter (p) {
                    return p.value > 0 ? p.value : ''
                  }
                }
              }
            },
            data: [],
            yAxisIndex: 1
          }]
        })
      },
      // 更新图表预计获得工时数据
      updatePlanGetWorkTime (data) {
        this.chart.setOption({
          series: [{
            name: '预计工时',
            data: data
          }]
        })
      },
      // 更新图表计划进度
      updateTotalProcess (data) {
        this.chart.setOption({
          series: [{
            name: '总进度',
            data: data
          }]
        })
      },
      // 更新图表标题
      updateTitle (title) {
        this.chart.setOption({
          title: [{
            text: title + ' 月预计工时&年度进展明细'
          }]
        })
      }
    },
    props: {
      className: {
        type: String,
        default: 'chart'
      },
      id: {
        type: String,
        default: 'chart'
      },
      width: {
        type: String,
        default: '200px'
      },
      height: {
        type: String,
        default: '200px'
      },
      title: {
        type: String,
        default: '错误'
      }
    },
    name: 'planChart.vue'
  }
</script>

<style scoped>

</style>
