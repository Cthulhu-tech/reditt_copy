import { useState, useEffect } from 'react';
import { Form } from "../interface/hook"

export const useForm = (callback:() => void, validate: (data: Form) => Form) => {

    const [error, setErrors] = useState<Form>({});
    const [dataForm, setValues] = useState<Form>({});
    const [isSubmitting, setIsSubmitting] = useState(false);
  
    const handleInput = (event:React.ChangeEvent<HTMLInputElement>) => setValues({...dataForm, [event.target.name]: event.target.value});
  
    const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
  
      event.preventDefault();
      setErrors(validate(dataForm));
      setIsSubmitting(true);
  
    };
  
    useEffect(() => {

      if (Object.keys(error).length === 0 && isSubmitting) {
        
        callback();
  
      }

    }, [error]);
  
    return {handleInput, handleSubmit, dataForm, error};
    
  };