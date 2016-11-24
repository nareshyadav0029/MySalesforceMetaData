//// Student Count Using Model Class And Map////
public class ModelStudentCount{
    public Map<String,List<String>> student_list{get;set;} 
    public Map<String,String> class_name{get;set;}
    public List<ModelStudentclass> modelstudent{get;set;}
    public ModelStudentCount(){
        student_list = new Map<String,List<String>>();
        class_name = new Map<String,String>();
        modelstudent = new List<ModelStudentclass>();
        List<Student__c> studentlist = [select Name , Class__c from Student__c];
        
        for(Student__c stu : studentlist){
            List<String> student = student_list.get(stu.Class__c);
            if(student==null){
                student = new List<String>(); 
            }
            student.add(stu.name);
            student_list.put(stu.Class__C,student);
        }
        
        ////    MODEL CLASS SETUP    ////
        
        integer i=1;
        List<Class__c> class_list = [select Name from Class__c];
        for(Class__c cls : class_list){
            class_name.put(cls.id,cls.name);
            ModelStudentclass msc = new ModelStudentclass();
            msc.sno = i;
            msc.student_count = student_list.get(cls.id).size();
            msc.classname = cls.name;
            msc.student_name = student_list.get(cls.id);
            modelstudent.add(msc);
            i++;
             
        }
        
    }
    
    ////    MODEL CLASS FOR ModelStudentCount    ////
    
    public class ModelStudentclass{
        public integer sno{get;set;}
        public integer student_count{get;set;}
        public String classname{get;set;}
        public List<String> student_name{get;set;}
    }
}