public with sharing class OffreEmploi {
    
    @AuraEnabled(cacheable=true)
    public static List<JobOfferWrapper> getJobOffersByCandidate(Id candidateId) {
        Set<Id> uniqueJobIds = new Set<Id>();
        List<JobOfferWrapper> jobOffers = new List<JobOfferWrapper>();

        
        List<Entretien__c> entretiens = [SELECT Id, Statut__c, Offre_Emploi__r.Id, Offre_Emploi__r.Name, Offre_Emploi__r.Statut__c
                                         FROM Entretien__c
                                         WHERE Candidat__c = :candidateId];

        for (Entretien__c entretien : entretiens) {
            if (!uniqueJobIds.contains(entretien.Offre_Emploi__r.Id)) {
                jobOffers.add(new JobOfferWrapper(
                    entretien.Offre_Emploi__r.Id,
                    entretien.Offre_Emploi__r.Name,
                    entretien.Offre_Emploi__r.Statut__c
                ));
                uniqueJobIds.add(entretien.Offre_Emploi__r.Id);
            }
        }

        return jobOffers;
    }

    public class JobOfferWrapper {
        @AuraEnabled public Id jobId;
        @AuraEnabled public String jobName;
        @AuraEnabled public String statut;

        public JobOfferWrapper(Id jobId, String jobName, String statut) {
            this.jobId = jobId;
            this.jobName = jobName;
            this.statut = statut;
        }
    }
}
