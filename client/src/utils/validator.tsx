import { Form } from "../interface/hook";

export const validate = (data: Form) => {

    let error:Form = {};

    if (!data.login)
        error.login = "Enter login";
    else if(!!!/^[A-Za-z0-9][A-Za-z0-9_]{0,18}$/.exec(data.login))
        error.login = "Login must be no more than 18 characters and contain only symbols and numbers";

    if (!data.password)
        error.password = "Enter password";
    else if(!!!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-zа-яА-ЯЙЁеё\d@$!%*?&]{8,}$/.exec(data.password))
        error.password = "The password must be at least 8 characters long, contain at least 1 number, a special character, and upper and lower case letters";
    else if (data.repeat_password && data.password !== data.repeat_password)
        error.repeat_password = "Passwords do not match";

    if(typeof data['repeat_password'] !== "undefined"){

        if(data.repeat_password.length === 0)
        error.repeat_password = "Please, repeate password";
        else if (data.password && data.repeat_password !== data.password)
        error.repeat_password = "Passwords do not match";

    }

    return error;

}