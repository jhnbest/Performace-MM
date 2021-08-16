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
  import 'tinymce/themes/silver'
  import 'tinymce/plugins/paste'
  import 'tinymce/plugins/image'
  import 'tinymce/plugins/link'
  import 'tinymce/plugins/code'
  import 'tinymce/plugins/table'
  import 'tinymce/plugins/lists'
  import 'tinymce/plugins/wordcount'

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
          'fontsizeselect fontselect | ' +
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
          language_url: `${this.baseUrl}/tinymce/langs/zh_CN.js`, // 如果语言包不存在，指定一个语言包路径
          // language_url: `workTimeMM/static/tinymce/langs/zh_CN.js`, // 如果语言包不存在，指定一个语言包路径
          skin_url: `${this.baseUrl}/tinymce/skins/ui/oxide`, // 如果主题不存在，指定一个主题路径
          // skin_url: `workTimeMM/static/tinymce/skins/ui/oxide`, // 如果主题不存在，指定一个主题路径
          language: 'zh_CN', // 语言
          height: '300px',
          plugins: this.plugins, // 插件
          toolbar: this.toolbar, // 工具栏
          branding: false, // 技术支持(Powered by Tiny || 由Tiny驱动)
          menubar: true, // 菜单栏
          theme: 'silver' // 主题
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
