package org.mountsinai.mortalitytriggersystem

class MortalityReviewForm {

    /*Patient Information*/
    long id
    String visitId
    String admitUnit
    String patientName
    String mrn
    Date dob
    String gender
    Date admitDateTime
    String admittingDiagnosis
    String primReasonTimeOfAdmission
    String dischargeDiagnosis
    Date dischargeDateTime
    String dischargeUnit
    Date expiredDateTime
    String hospService
    String lastAttending
    String dictationCode
    String serviceTeam
    String hospitalSite
    String hospitalName
    String patientUnitAtDeath
    String dischargeAttendeeName
    String dischargingDepartment
    String dischargingDivision
    String comments
    Boolean wasPatTransferredFacility
    String patTransferredComment
    Boolean isIcuStay
    Boolean isPatDiedLt24hrsDischarge
    Boolean isDeathWt24hrAdmission
    Boolean wasCaseAptME
    Boolean wasCaseAccptByME
    Boolean wasCaseReqMe
    Boolean isMetAutopsy
    Boolean isAutopsyPerformed
    String summaryOfHospCourse
    Boolean isPatInfoAccurate
    String patInfoComment
    Boolean isHospice

    /* Major Comorbidities POA*/
    Boolean isComorbAtrialFibrillation
    Boolean isCerebrovascularAccident
    Boolean isChronicKidneyDisease
    Boolean isCirrhosis
    Boolean isCognitiveImpairment
    Boolean isAsthma
    Boolean isCoronaryArteryDisease
    Boolean isDiabetes
    Boolean isDementia
    Boolean isComorbHeartFailure
    Boolean isHyperTension
    Boolean isMalignancy
    Boolean isMorbidObesity
    Boolean isNeurologicalDisorders
    Boolean isObstructiveSleepApnea
    Boolean isPeripheralVascularDisease
    Boolean isValvularHeartDisease
    Boolean isComorbiditiesOther
    String comorbiditiesOtherComment
    Boolean isMajComorbNa

    /*Complication Acquired in Hospital */
    Boolean isAcuteKidneyInjury
    Boolean isAcuteMyocardialInfraction
    Boolean isAlterredMentalStatus
    Boolean isHospAtrialFibrillation
    Boolean isCVA
    Boolean isDVTOrVTE
    Boolean isHospitalFall
    Boolean isGiBleed
    Boolean isHospitalHeartFailure
    Boolean isHospHospAcqInfection
    String hospAcqInfComment
    Boolean isMedicalError
    String medicalErrorComment
    Boolean isPressureUlcer
    Boolean isHospitalSepsis
    Boolean isSyncope
    Boolean isTypeOrLocation
    String typeOrLocationComment
    Boolean isHospitalOther
    String hospitalOtherComment
    Boolean isCompAcqHospNA

    /* Major Supportive Interventions*/
    Boolean isCentralLine
    Boolean isCPR
    Boolean isSupportiveHemodialysis
    Boolean isIntubation
    Boolean isSupportiveVasopressors
    Boolean isSupportiveOther
    String supportiveOtherComment
    Boolean isMajSuppInterNA

    /* Major Invasive Interventions*/
    Boolean isBronchoscopy
    Boolean isCardiacCatheterization
    Boolean isInvasiveHemodialysis
    Boolean isInvasiveOther
    String invasiveOtherComment
    Boolean isInterventionalRadioProc
    Boolean isSergicalProcedure
    String sergicalProcedureComment
    Boolean isMajInvInterNA

    /* Procedure Related Complications*/
    Boolean isProcedureCardiac
    String cardiacComment
    Boolean isNeurologicalInjury
    String neuroInjuryComment
    Boolean isDeadWithin72HoursOfProc
    Boolean isProcedurePulmonary
    Boolean isExcessiveBleeding
    Boolean isRenalFailure
    Boolean isProcedureHepatic
    Boolean isUnanticipatedTransfusion
    Boolean isInfection
    String infectionComment
    Boolean isProcedureOther
    String procedureOtherComment
    String postOpSummary
    Boolean isProcRelCompNA
    Boolean isHypotension
    Boolean isStroke
    Boolean isPneumothoraxRate
    Boolean isHemhgeOrHematRate
    Boolean isPeOrDeVenThrbRate

    /*Cause of Death*/
    Boolean isBleeding
    Boolean isDeathCauseCardiac
    Boolean isDeathCauseHepatic
    Boolean isDeathCausePulmonary
    Boolean isDeathCauseRenal
    Boolean isDeathCauseSepsis
    Boolean isDeathCauseOther
    String deathCauseOtherComment
    Boolean wasPatICUTimeAdmission
    Boolean expectedPatToDieAdmission
    Boolean isNaturalCoursePatIllness
    Boolean isRelUnderlyingConditions
    String expPatDieAdmissionComment
    Boolean isPalliativeCare
    Boolean havePalliativeCareContacted
    Boolean wasDnrPriorToAdmission
    Boolean wasDnrAppliedAtAdmission
    Boolean didDnrAfterToAdmission

    /*Contributing Factors*/
    Boolean isAdverseDrugEvent
    Boolean isOmissionOfCare
    Boolean isDelayInTreatment
    Boolean isPatientCompliance
    Boolean isElectronicMedicalRecord
    Boolean isPoorCommunication
    Boolean isContributingFall
    Boolean isPoorHandoff
    Boolean isFailureToAftercare
    Boolean isPoorDocumentation
    Boolean isFailureToEscalate
    Boolean isSupervision
    Boolean isHospAcqCondition
    Boolean isSurgicalError
    Boolean isContributingHospInfection
    Boolean isTechniqueError
    Boolean doesDeathRequireFurtherRev
    Boolean isContFactOther
    String contFactOtherComment
    Boolean isContFactNA

    Facility facility
    Department dept
    Speciality speciality
    MortalityUser admin
    MortalityUser lead
    MortalityUser reviewer
    ReviewStatus status

    Date dateCreated
    String createdBy
    Date dateUpdated
    String updatedBy
    Boolean isArchive

    static constraints = {
        id (nullable:true)
        visitId (nullable:true)
        admitUnit (nullable:true)
        patientName (nullable:true)
        mrn (nullable:true)
        dob (nullable:true)
        gender (nullable:true)
        admitDateTime (nullable:true)
        admittingDiagnosis (nullable:true)
        primReasonTimeOfAdmission (nullable:true)
        dischargeDiagnosis (nullable:true)
        dischargeDateTime (nullable:true)
        dischargeUnit (nullable:true)
        expiredDateTime (nullable:true)
        hospService (nullable:true)
        lastAttending (nullable:true)
        dictationCode (nullable:true)
        serviceTeam (nullable:true)
        hospitalSite (nullable:true)
        hospitalName (nullable:true)
        patientUnitAtDeath (nullable:true)
        dischargeAttendeeName (nullable:true)
        dischargingDepartment (nullable:true)
        dischargingDivision (nullable:true)
        comments (nullable:true)
        wasPatTransferredFacility (nullable:true)
        patTransferredComment (nullable:true)
        isIcuStay (nullable:true)
        isPatDiedLt24hrsDischarge (nullable:true)
        isDeathWt24hrAdmission (nullable:true)
        wasCaseAptME (nullable:true)
        wasCaseAccptByME (nullable:true)
        wasCaseReqMe (nullable:true)
        isMetAutopsy (nullable:true)
        isAutopsyPerformed (nullable:true)
        summaryOfHospCourse (nullable:true)
        isPatInfoAccurate (nullable:true)
        patInfoComment (nullable:true)
        isComorbAtrialFibrillation (nullable:true)
        isCerebrovascularAccident (nullable:true)
        isChronicKidneyDisease (nullable:true)
        isCirrhosis (nullable:true)
        isCognitiveImpairment (nullable:true)
        isAsthma (nullable:true)
        isCoronaryArteryDisease (nullable:true)
        isDiabetes (nullable:true)
        isDementia (nullable:true)
        isComorbHeartFailure (nullable:true)
        isHyperTension (nullable:true)
        isMalignancy (nullable:true)
        isMorbidObesity (nullable:true)
        isNeurologicalDisorders (nullable:true)
        isObstructiveSleepApnea (nullable:true)
        isPeripheralVascularDisease (nullable:true)
        isValvularHeartDisease (nullable:true)
        isComorbiditiesOther (nullable:true)
        comorbiditiesOtherComment (nullable:true)
        isAcuteKidneyInjury (nullable:true)
        isAcuteMyocardialInfraction (nullable:true)
        isAlterredMentalStatus (nullable:true)
        isHospAtrialFibrillation (nullable:true)
        isMajComorbNa(nullable:true)

        isCVA (nullable:true)
        isDVTOrVTE (nullable:true)
        isHospitalFall (nullable:true)
        isGiBleed (nullable:true)
        isHospitalHeartFailure (nullable:true)
        isHospHospAcqInfection (nullable:true)
        hospAcqInfComment (nullable:true)
        isMedicalError (nullable:true)
        medicalErrorComment (nullable:true)
        isPressureUlcer (nullable:true)
        isHospitalSepsis (nullable:true)
        isSyncope (nullable:true)
        isTypeOrLocation (nullable:true)
        typeOrLocationComment (nullable:true)
        isHospitalOther (nullable:true)
        hospitalOtherComment (nullable:true)
        isCompAcqHospNA (nullable: true)
        isCentralLine (nullable:true)
        isCPR (nullable:true)
        isSupportiveHemodialysis (nullable:true)
        isIntubation (nullable:true)
        isSupportiveVasopressors (nullable:true)
        isSupportiveOther (nullable:true)
        supportiveOtherComment (nullable:true)
        isMajSuppInterNA (nullable: true)
        isBronchoscopy (nullable:true)
        isCardiacCatheterization (nullable:true)
        isInvasiveHemodialysis (nullable:true)
        isInvasiveOther (nullable:true)
        invasiveOtherComment (nullable:true)
        isInterventionalRadioProc (nullable:true)
        isSergicalProcedure (nullable:true)
        sergicalProcedureComment (nullable:true)
        isMajInvInterNA (nullable: true)
        isProcedureCardiac (nullable:true)
        cardiacComment (nullable:true)
        isNeurologicalInjury (nullable:true)

        isHypotension (nullable:true)
        isStroke (nullable:true)
        isPneumothoraxRate (nullable:true)
        isHemhgeOrHematRate (nullable:true)
        isPeOrDeVenThrbRate (nullable:true)

        neuroInjuryComment (nullable:true)
        isDeadWithin72HoursOfProc (nullable:true)
        isProcedurePulmonary (nullable:true)
        isExcessiveBleeding (nullable:true)
        isRenalFailure (nullable:true)
        isProcedureHepatic (nullable:true)
        isUnanticipatedTransfusion (nullable:true)
        isInfection (nullable:true)
        infectionComment (nullable:true)
        isProcedureOther (nullable:true)
        procedureOtherComment (nullable:true)
        postOpSummary (nullable:true)
        isProcRelCompNA (nullable: true)
        isHospice (nullable:true)
        isPalliativeCare (nullable:true)
        havePalliativeCareContacted (nullable:true)
        wasDnrPriorToAdmission (nullable:true)
        wasDnrAppliedAtAdmission (nullable:true)
        didDnrAfterToAdmission (nullable:true)
        isBleeding (nullable:true)
        isDeathCauseCardiac (nullable:true)
        isDeathCauseHepatic (nullable:true)
        isDeathCausePulmonary (nullable:true)
        isDeathCauseRenal (nullable:true)
        isDeathCauseSepsis (nullable:true)
        isDeathCauseOther (nullable:true)
        deathCauseOtherComment (nullable:true)
        wasPatICUTimeAdmission (nullable:true)
        expectedPatToDieAdmission (nullable:true)
        isNaturalCoursePatIllness (nullable:true)
        isRelUnderlyingConditions (nullable:true)
        expPatDieAdmissionComment (nullable:true)
        isAdverseDrugEvent (nullable:true)
        isOmissionOfCare (nullable:true)
        isDelayInTreatment (nullable:true)
        isPatientCompliance (nullable:true)
        isElectronicMedicalRecord (nullable:true)
        isPoorCommunication (nullable:true)
        isContributingFall (nullable:true)
        isPoorHandoff (nullable:true)
        isFailureToAftercare (nullable:true)
        isPoorDocumentation (nullable:true)
        isFailureToEscalate (nullable:true)
        isSupervision (nullable:true)
        isHospAcqCondition (nullable:true)
        isSurgicalError (nullable:true)
        isContributingHospInfection (nullable:true)
        isTechniqueError (nullable:true)
        doesDeathRequireFurtherRev (nullable:true)
        isContFactOther (nullable:true)
        contFactOtherComment (nullable:true)
        isContFactNA (nullable:true)
        facility (nullable:true)
        dept (nullable:true)
        speciality (nullable:true)
        admin (nullable:true)
        lead (nullable:true)
        reviewer (nullable:true)
        status (nullable:true)
        dateCreated (nullable:true)
        createdBy (nullable:true)
        dateUpdated (nullable:true)
        updatedBy (nullable:true)
        isArchive(nullable:true)
    }

    static mapping = {
        version false
        facility fetch: 'join'
        speciality fetch: 'join'
        lead fetch: 'join'
    }
}
