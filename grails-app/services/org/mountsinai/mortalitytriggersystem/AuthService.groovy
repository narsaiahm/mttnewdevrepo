package org.mountsinai.mortalitytriggersystem

import grails.transaction.Transactional
import org.springframework.context.ApplicationContextAware
import org.springframework.context.ApplicationContext

@Transactional
class AuthService implements ApplicationContextAware {

    ApplicationContext applicationContext

    def fetchUserInfo(params, email){
        def users = []
        if(email?.split("|")?.size()>0){
            def emailList = email.split("\\|")
            users = MortalityUser.withCriteria {
                and{
                    or {
                        emailList.each {
                            ilike('email', "%$it%")
                        }
                    }
                    eq('activeFlag',true)
                }
            }
        }else{
            users = MortalityUser.findAllByEmailIlikeAndActiveFlag(email,true)
        }
        return users
    }

}
