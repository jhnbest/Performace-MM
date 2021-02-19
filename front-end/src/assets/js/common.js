/* eslint-disable */
import { Message, MessageBox } from 'element-ui'
import router from '../../router'
import { getCurApplyAbleMonth } from '@/config/interface'
import el from "element-ui/src/locale/lang/el";

const commonFn = {
	toast (str, type, showClose, onCloseFn) {
		let time = 2000
		if (showClose) {
			time = 30000
		}
		Message({
			showClose: showClose,
			message: str,
			type: type,
			duration: time,
			onClose: onCloseFn
		})
	},
  // 月份转换成英文
  MonthToString (month) {
	  switch (month) {
	    case '1':
        return 'January'
      case '2':
        return 'February'
      case '3':
        return 'March'
      case '4':
        return 'April'
      case '5':
        return 'May'
      case '6':
        return 'June'
      case '7':
        return 'July'
      case '8':
        return 'August'
      case '9':
        return 'September'
      case '10':
        return 'October'
      case '11':
        return 'November'
      case '12':
        return 'December'
      default:
        return 'error'
    }
  },
  // 月份转换成英文
  mStringToNumber (mString) {
    switch (mString) {
      case 'January':
        return '01'
      case 'February':
        return '02'
      case 'March':
        return '03'
      case 'April':
        return '04'
      case 'May':
        return '05'
      case 'June':
        return '06'
      case 'July':
        return '07'
      case 'August':
        return '08'
      case 'September':
        return '09'
      case 'October':
        return '10'
      case 'November':
        return '11'
      case 'December':
        return '12'
      default:
        return 'error'
    }
  },
	// 刷新当前页面
	shallowRefresh (name) {
		console.log('shallowRefresh name=' + name)
		router.replace({
			path: '/refresh',
			query: {
				name: name
			}
		})
	},
	// 弹框
	msgBox (type, title, message, confirm, cancel) {
		switch (type) {
			case 'alert':
				MessageBox.alert(message, title, {
						dangerouslyUseHTMLString: true
					})
					.then(() => {
						// 点击确定
					})
					.catch(action => {
						// 点击取消
					})
				break
			case 'confirm':
				MessageBox.confirm(message, title, {
					confirmButtonText: '确定',
					cancelButtonText: '取消',
					cancelButtonClass: 'messagebox-cancel-button',
					dangerouslyUseHTMLString: true,
					type: 'error'
				}).then(() => {
					if (!confirm) {
						Message({
							message: title + '失败!',
							type: 'success',
							duration: 1500
						})
					} else {
						confirm()
					}
				}).catch(() => {
					if (!cancel) {
						Message({
							message: '已取消',
							type: 'info',
							duration: 1500
						})
					} else {
						cancel()
					}
				})
				break
		}
	}
}

export default commonFn
