import { environment } from 'src/environments/environment';
import { Injectable } from '@angular/core';
import { FornecedorModel } from '../models/FornecedorModel';
import { Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { map } from 'rxjs/operators';


@Injectable({
  providedIn: 'root'
})
export class FornecedorService {


  public fornecedors: FornecedorModel[] = [];

  constructor(private httpClient: HttpClient) { }

  public put(fornecedor: FornecedorModel): Observable<any> {
    return this.httpClient.put(`${environment.url}/fornecedor/`, fornecedor);
  }



  public add(fornecedor: FornecedorModel): Observable<any> {

    return this.httpClient.post(`${environment.url}/fornecedor/`, fornecedor)
    .pipe(
      map((response: any) => {
     
        const jsonResponse = response.json(); // Use response.json() no Angular 5 ou anterior
        // Ou use response.body.json() no Angular 6 ou posterior

        console.log(jsonResponse); // Imprime o valor retornado no console

        return jsonResponse; 
      // Use response.json() no Angular 5 ou anterior
        // Ou use response.body.json() no Angular 6 ou posterior
      })
     
    );
  
  }


  public get(idx: number): Observable<any> {
    return this.httpClient.get(`${environment.url}/fornecedor/${idx}`);
  }

  public list(): Observable<any> {
    // console.log(this.httpClient.get(`${environment.url}/fornecedor/`))
    return this.httpClient.get(`${environment.url}/fornecedor/`);
  }

  public delete(id: number): Observable<any> {
    return this.httpClient.delete(`${environment.url}/fornecedor/${id}`);
  }

}
