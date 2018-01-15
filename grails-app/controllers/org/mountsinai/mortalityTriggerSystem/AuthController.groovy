package org.mountsinai.mortalitytriggersystem

import org.mountsinai.mortalitytriggersystem.AdminConstants

import javax.sql.rowset.spi.TransactionalWriter

import static grails.util.Environment.PRODUCTION
import static grails.util.Environment.getCurrentEnvironment
import grails.transaction.Transactional
import org.slf4j.Logger
import org.slf4j.LoggerFactory

class AuthController {

    def authService

    static defaultAction = "login"
    static Logger log = LoggerFactory.getLogger(AuthController.class)

    /**
     * this method authenticates userid and password, returns SUCCESS and FAILED responses
     * @param param
     * @return
     */
    @Transactional
    def login() {
        clearSessionData()
        def userId = request.getHeader('sm_user')
        def userName = request.getHeader('MSNYU_FULLNAME')
        def smEmail = request.getHeader('email')

        println "login --> $userId"
        println "userName --> $userName"
        println "email --> $smEmail"

        def email = smEmail//params.email != null ? params.email : 'Carol.Green@mountsinai.org'
        if(currentEnvironment != PRODUCTION) {
            if(!userId) {
                userId = 'jullieswain'
                email = //'troy.tomilonus@mountsinai.org'//'Carol.Green@mountsinai.org' ////'kathy.navid@mountsinai.org'//'julie.swain@mountsinai.org'
                //'Lori.Finkelstein-Blond@mountsinai.org'
                'glenn.kashan@mountsinai.org'//'Carol.Green@mountsinai.org' //
               // email = 'narsaiah.madugula@mountsinai.org'//'julie.swain@mountsinai.org'//'Michael.Bronson@mountsinai.org'
            }
        }
        session['userId'] = userId
        session['email'] = email
        log.info("login --> $userId")
        log.info("email --> $email")
        def users = authService.fetchUserInfo(params, email)
        println users
        if(users && users.size() > 0) {
            //check database for roles
            def totalRoles = users.size()
            session.user = users[0]
            session.allUsers = users
            if(totalRoles > 1){
                session.userFacilities = users.facility.id
            }
            println session
            //to open review form directly, if accessed through email link
            if(params.isEmailLink.equals("1")){
                redirect(controller:'mortality',action:'review',params:params)
            }else if (users[0].role.roleName == AdminConstants.ADMIN) {
                redirect(controller:'mortality',action:'adminDashboard')
            }else if(users[0].role.roleName == AdminConstants.QUALITY_LEAD || users[0].role.roleName == AdminConstants.ADHOC) {
                redirect(controller:'mortality',action:'qlDashboard')
            }
        } else {
            //redirect uri: '/logout.openam
            if(params.isEmailLink.equals("1") && params.userId){
                redirect(controller: "auth", action: "login")
            }else{
                render AdminConstants.NO_FORM_ASSIGNED_MSG
            }
        }
    }
//test comment added
    private void clearSessionData() {
        session.getAttributeNames().each {
            session[it] = null
        }
    }

    def dummyLogin(){
        clearSessionData()
        def email = params.email != null ? params.email : 'murtaza.partapurwala@mssm.edu'
        session['email'] = email
        log.info("email --> $email")
        def users = authService.fetchUserInfo(params, email)
        println users
        if(users && users.size() > 0) {
            //check database for roles
            def totalRoles = users.size()
            session.user = users[0]
            session.allUsers = users
            if(totalRoles > 1){
                session.userFacilities = users.facility.id
            }
            println session
            //to open review form directly, if accessed through email link
            if(params.isEmailLink.equals("1")){
                redirect(controller:'mortality',action:'review',params:params)
            }else if (users[0].role.roleName == AdminConstants.ADMIN) {
                redirect(controller:'mortality',action:'adminDashboard')
            }else if(users[0].role.roleName == AdminConstants.QUALITY_LEAD || users[0].role.roleName == AdminConstants.ADHOC) {
                redirect(controller:'mortality',action:'qlDashboard')
            }
        } else {
            //redirect uri: '/logout.openam
            if(params.isEmailLink.equals("1") && params.userId){
                redirect(controller: "auth", action: "login")
            }else{
                render AdminConstants.NO_FORM_ASSIGNED_MSG
            }
        }
    }


    def logout() {
        session.invalidate()
        redirect uri: '/logout.openam'
    }

}
