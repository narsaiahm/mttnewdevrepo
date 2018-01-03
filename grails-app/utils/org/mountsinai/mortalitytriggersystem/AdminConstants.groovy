package org.mountsinai.mortalitytriggersystem

/**
 * Created by bansaa03 on 8/16/17.
 */
class AdminConstants {

    public static final String LOCAL = 'http://localhost:9090/mortalitytriggersystem'
    public static final String DEV = 'http://msh-dev01.mountsinai.org/mortalitytriggersystem'
    public static final String QA = 'http://msh-qa01.mountsinai.org/mortalitytriggersystem'
    public static final String PROD = 'https://intranet2.mountsinai.org/mortalitytriggersystem'
    public static final String HELP_LINK ='http://msh-dev01.mountsinai.org/static/MTT_Help.pdf'

    public static final String Y = 'Y'
    public static final String N = 'N'

    public static final String ADMIN = 'ADMIN'
    public static final String QUALITY_LEAD = 'QUALITY_LEAD'
    public static final String ADHOC = 'ADHOC'

    public static final String SERVER_NAME_LOCALHOST ='localhost'
    public static final String SERVER_NAME_MSH_DEV = 'msh-dev'
    public static final String SERVER_NAME_MSH_QA = 'msh-qa'

    public static final String EMAIL_FROM_ADDRESS = 'do-not-reply@mountsinai.org'
    public static final String EMAIL_REVIEW_FORM_NOTIFICATION_SUBJECT = 'Mortality Review Trigger Tool - Action Required'
    public static final String EMAIL_FOURTEEN_DAYS_REMINDER_SUBJECT = 'Mortality Review Trigger Tool - 14 Days Reminder'
    public static final String EMAIL_REMINDER_NOTICE_SUBJECT = 'Mortality Review Trigger Tool - Reminder Notice'

    public static final String REMINDER_SENT_SUCCESS_MSG = "Reminder Email sent successfully"

    public static final String NO_FORM_ASSIGNED_MSG = "You do not have any Form assigned"

    public static final String NOT_AUTHORISED_VISIT_MSG = "You are not authorised to visit this link"
    public static final String UN_ASSIGN_USER_WARNING_MSG = "All Assigned/Incompleted review forms assigned to the user will be reset once user is unassigned from the system"

}
