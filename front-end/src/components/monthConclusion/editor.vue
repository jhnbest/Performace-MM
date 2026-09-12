<template>
  <div class='tinymce-editor'>
    <editor
      v-model='myValue'
      :init='init'
      :disabled='disabled'
      @onClick='onClick'
    ></editor>
  </div>
</template>

<script>
  import tinymce from 'tinymce'
  import Editor from '@tinymce/tinymce-vue'
  import 'tinymce/icons/default/icons' // TinyMCE 6 需要显式导入图标
  import 'tinymce/models/dom' // TinyMCE 6 需要显式导入 DOM model
  import 'tinymce/themes/silver'
  import 'tinymce/plugins/image'
  import 'tinymce/plugins/link'
  import 'tinymce/plugins/code'
  import 'tinymce/plugins/table'
  import 'tinymce/plugins/lists'
  import 'tinymce/plugins/wordcount'
  // 注：粘贴过滤在 TinyMCE 6 中已内置到核心，无需单独加载 paste 插件，
  // 通过 init 中的 paste_* 配置控制粘贴格式过滤

  export default {
    components: {
      Editor
    },
    props: {
      value: {
        type: String,
        default: ''
      },
      baseUrl: {
        type: String,
        default: window.location.origin ? window.location.origin : ''
      },
      disabled: {
        type: Boolean,
        default: false
      },
      plugins: {
        type: [String, Array],
        default:
          'link lists table wordcount'
      },
      toolbar: {
        type: [String, Array],
        default:
          'bold italic underline | ' +
          'fontsizeselect fontselect styleselect | ' +
          'forecolor backcolor | ' +
          'alignleft aligncenter alignright alignjustify | ' +
          'bullist numlist | ' +
          'outdent indent blockquote | ' +
          'undo redo | ' +
          'removeformat'
      }
    },
    data () {
      return {
        init: {
          //开发环境路径配置
          // base_url: `${this.baseUrl}/tinymce`, // TinyMCE 静态资源根目录，修复 webpack 下 baseURL 推断错误的问题
          // language_url: `${this.baseUrl}/tinymce/langs/zh_CN.js`, // 如果语言包不存在，指定一个语言包路径
          // skin_url: `${this.baseUrl}/tinymce/skins/ui/oxide`, // 如果主题不存在，指定一个主题路径
          //生产环境路径配置
          base_url: '/static/tinymce', // TinyMCE 静态资源根目录，修复 webpack 下 baseURL 推断错误的问题
          language_url: '/static/tinymce/langs/zh_CN.js', // 如果语言包不存在，指定一个语言包路径
          skin_url: '/static/tinymce/skins/ui/oxide', // 如果主题不存在，指定一个主题路径
          language: 'zh_CN', // 语言
          height: '500px', // 默认展开高度
          plugins: this.plugins, // 插件
          toolbar: this.toolbar, // 工具栏
          branding: false, // 技术支持(Powered by Tiny || 由Tiny驱动)
          promotion: false, // 隐藏右上角"upgrade"升级提示图标
          menubar: true, // 菜单栏
          // == 行间距调整（通过样式下拉"行距"选项设置 line-height） ==
          style_formats: [
            {
              title: '行距',
              items: [
                { title: '单倍行距', block: 'p', styles: { 'line-height': '1' } },
                { title: '1.15倍行距', block: 'p', styles: { 'line-height': '1.15' } },
                { title: '1.5倍行距', block: 'p', styles: { 'line-height': '1.5' } },
                { title: '双倍行距', block: 'p', styles: { 'line-height': '2' } }
              ]
            }
          ],
          // == 粘贴格式过滤（TinyMCE 6 内置 paste，仅保留基础排版，剥离源颜色/字体/字号/背景） ==
          paste_as_text: false, // 保留段落/列表结构，而非强制纯文本
          paste_remove_styles_if_webkit: true, // 开启 WebKit 内联样式过滤（为 true 才会执行下方白名单剥离）
          paste_webkit_styles: 'font-weight font-style text-decoration', // 仅保留粗/斜/下划线，剥离颜色/字体/字号等
          paste_merge_formats: true, // 粘贴时合并相邻相同格式
          smart_paste: true // 智能粘贴（链接/表格等智能转换）
        },
        myValue: this.value
      }
    },
    mounted () {
      tinymce.init({})
    },
    methods: {
      calcWidth () {
        return document.body.clientWidth / 2 + 'px'
      },
      onClick () {
      }
    },
    watch: {
      value (newValue) {
        this.myValue = newValue
      },
      myValue (newValue) {
        this.$emit('input', newValue)
      }
    }
  }
</script>.
