////WITHOUT MODEL CLASS////

public class mapDemoStudentCount{
    public Map<String,List<String>> student_count{get;set;}
    public Map<String,String> class_list{get;set;}
    public mapDemoStudentCount(){
        student_count = new Map<String,List<String>>();
        class_list = new Map<string,String>();
        List<Class__c> class_name = [select Name from Class__c];
        for(Class__c c: class_name){
            class_list.put(c.id,c.Name);
        }
        
        List<Student__c> student_list = [select name,Class__c from Student__c];
        for(Student__c stu : student_list){
            List<String> studentlist = student_count.get(class_list.get(stu.Class__c));
            if(studentlist == null){
                studentlist = new List<String>();
            }
            studentlist.add(stu.name);
            student_count.put(class_list.get(stu.Class__c),studentlist);    
        }
        System.debug('#####'+student_count);           
    }
}