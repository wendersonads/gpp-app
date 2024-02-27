import { environment } from 'src/environments/environment';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { PecaEstoqueModel } from '../models/PecaEstoqueModel';


@Injectable({
  providedIn: 'root'
})
export class PecaEstoqueService {

  public pecasEstoque: PecaEstoqueModel[] = [];

  constructor(private httpClient: HttpClient) { }

  public post(peca: PecaEstoqueModel): Observable<any>{
    return this.httpClient.post(`${environment.url}/pecasestoque/`, peca);
  }

  public add(peca: PecaEstoqueModel): Observable<any>{
    return this.httpClient.post(`${environment.url}/pecasestoque/`, peca);
  }

  public get(idx: number): Observable<any>{
    return this.httpClient.get(`${environment.url}/pecasestoque/${idx}`);
  }

  public list(): Observable<any>{
     console.log(this.httpClient.get("${environment.url}/pecasestoque/"))
    return this.httpClient.get(`${environment.url}/pecasestoque/`);
  }

  public delete(id: number): Observable<any>{
    return this.httpClient.delete(`${environment.url}/pecasestoque/${id}`);
  }

}
